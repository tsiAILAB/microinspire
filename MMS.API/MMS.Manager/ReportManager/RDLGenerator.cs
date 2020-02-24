using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Xml;
using MMS.Core;

namespace MMS.Manager
{
    public static class RDLGenerator
    {
        public static List<ReportColumn> GetFields(DataColumnCollection columns, List<string> hideCols = null)
        {
            if (hideCols.IsNull()) hideCols = new List<string>();
            var fields = new List<ReportColumn>();
            foreach (DataColumn col in columns)
            {
                if (hideCols.Contains(col.ColumnName)) continue;
                fields.Add(new ReportColumn { Name = col.ColumnName, Header = col.ColumnName.SeparateWords(), FieldType = col.DataType.ToString() });
            }
            return fields;
        }
        public static XmlDocument GenerateRdl(string dataSetName, List<ReportColumn> fieldList)
        {
            var xmlDoc = CreateDocument();
            var report = CreateReportBase(xmlDoc);
            CreateReportDataSet(report, xmlDoc, dataSetName, fieldList);
            CreateReportBody(report, xmlDoc, dataSetName, fieldList);
            return xmlDoc;
        }

        private static XmlDocument CreateDocument()
        {
            var doc = new XmlDocument();
            var xmlData = @"<Report
                                xmlns:rd='http://schemas.microsoft.com/SQLServer/reporting/reportdesigner'
                                xmlns='http://schemas.microsoft.com/sqlserver/reporting/2010/01/reportdefinition'>
                            </Report>";
            doc.Load(new StringReader(xmlData));
            return doc;
        }
        private static XmlElement CreateReportBase(XmlDocument doc)
        {
            // Report element
            var report = (XmlElement)doc.FirstChild;
            AddElement(report, "AutoRefresh", "0");
            AddElement(report, "ConsumeContainerWhitespace", "true");
            //DataSources element
            var dataSources = AddElement(report, "DataSources", null);
            //DataSource element
            var dataSource = AddElement(dataSources, "DataSource", null);
            AddAttribute(dataSource, doc, "Name", "EXPORT");
            var connectionProperties = AddElement(dataSource, "ConnectionProperties", null);
            AddElement(connectionProperties, "DataProvider", "SQL");
            AddElement(connectionProperties, "ConnectString", "/* Local Connection */");
            return report;
        }
        private static void CreateReportDataSet(XmlElement report, XmlDocument doc, string dataSetName, List<ReportColumn> fieldList)
        {
            //DataSets element
            var dataSets = AddElement(report, "DataSets", null);
            var dataSet = AddElement(dataSets, "DataSet", null);
            AddAttribute(dataSet, doc, "Name", dataSetName);
            //Query element
            var query = AddElement(dataSet, "Query", null);
            AddElement(query, "DataSourceName", "EXPORT");
            AddElement(query, "CommandText", "/* Local Query */");
            //Fields element
            var fields = AddElement(dataSet, "Fields", null);
            foreach (var field in fieldList)
            {
                CreateDataSetFields(fields, doc, field);
            }
        }
        private static void CreateReportBody(XmlElement report, XmlDocument doc, string dataSetName, List<ReportColumn> fieldList)
        {
            //ReportSections element
            var reportSections = AddElement(report, "ReportSections", null);
            var reportSection = AddElement(reportSections, "ReportSection", null);
            AddElement(reportSection, "Width", "6in");
            AddElement(reportSection, "Page", null);
            var body = AddElement(reportSection, "Body", null);
            AddElement(body, "Height", "0.625in");
            var reportItems = AddElement(body, "ReportItems", null);
            // Tablix element
            var tablix = AddElement(reportItems, "Tablix", null);
            AddAttribute(tablix, doc, "Name", "tblExport");
            AddElement(tablix, "DataSetName", dataSetName);
            AddElement(tablix, "Width", "6in");
            var tablixBody = AddElement(tablix, "TablixBody", null);
            //TablixColumns element
            var tablixColumns = AddElement(tablixBody, "TablixColumns", null);
            foreach (var field in fieldList)
            {
                CreateColumn(tablixColumns, field.Width);
            }

            var tablixRows = AddElement(tablixBody, "TablixRows", null);
            var tablixCellHeaders = CreateRow(tablixRows, "0.4in");
            var tablixCellRows = CreateRow(tablixRows);
            foreach (var field in fieldList)
            {
                CreateHeaderCell(tablixCellHeaders, doc, field.Name, field.Header);
                CreateRowCell(tablixCellRows, doc, field);
            }

            //End of TablixBody

            //TablixColumnHierarchy element
            var tablixColumnHierarchy = AddElement(tablix, "TablixColumnHierarchy", null);
            var tablixMembers = AddElement(tablixColumnHierarchy, "TablixMembers", null);
            foreach (var field in fieldList)
            {
                CreateTablixMember(tablixMembers, field.Name);
            }

            //TablixRowHierarchy element
            var tablixRowHierarchy = AddElement(tablix, "TablixRowHierarchy", null);
            tablixMembers = AddElement(tablixRowHierarchy, "TablixMembers", null);
            var tablixMember = AddElement(tablixMembers, "TablixMember", null);
            AddElement(tablixMember, "KeepWithGroup", "After");
            AddElement(tablixMember, "KeepTogether", "true");
            tablixMember = AddElement(tablixMembers, "TablixMember", null);
            var group = AddElement(tablixMember, "Group", null);
            AddAttribute(group, doc, "Name", "Details");
        }

        private static void CreateDataSetFields(XmlElement fields, XmlDocument doc, ReportColumn rfield)
        {
            var field = AddElement(fields, "Field", null);
            AddAttribute(field, doc, "Name", rfield.Name);
            AddElement(field, "DataField", rfield.Name);
            AddRdElement(field, "rd:TypeName", rfield.FieldType);
        }
        private static XmlElement CreateColumn(XmlElement tablixColumns, string width)
        {
            var tablixColumn = AddElement(tablixColumns, "TablixColumn", null);
            AddElement(tablixColumn, "Width", width);
            return tablixColumn;
        }

        private static XmlElement CreateRow(XmlElement tablixRows, string height = "0.27373in")
        {
            var tablixRow = AddElement(tablixRows, "TablixRow", null);
            AddElement(tablixRow, "Height", height);
            var tablixCells = AddElement(tablixRow, "TablixCells", null);
            return tablixCells;
        }
        private static void CreateTablixMember(XmlElement tablixMembers, string propertyname)
        {
            AddElement(tablixMembers, "TablixMember", null);
        }
        private static void CreateRowCell(XmlElement tablixCells, XmlDocument doc, ReportColumn field)
        {
            XmlElement tablixCell;
            XmlElement cellContents;
            XmlElement textbox;
            XmlElement paragraphs;
            XmlElement paragraph;
            XmlElement textRuns;
            XmlElement textRun;
            XmlElement style;
            XmlElement border;

            tablixCell = AddElement(tablixCells, "TablixCell", null);
            cellContents = AddElement(tablixCell, "CellContents", null);
            textbox = AddElement(cellContents, "Textbox", null);
            AddAttribute(textbox, doc, "Name", field.Name);
            //AddElement(textbox, "CanGrow", "true");
            AddElement(textbox, "KeepTogether", "true");
            paragraphs = AddElement(textbox, "Paragraphs", null);
            paragraph = AddElement(paragraphs, "Paragraph", null);
            textRuns = AddElement(paragraph, "TextRuns", null);
            textRun = AddElement(textRuns, "TextRun", null);
            AddElement(textRun, "Value", $"=Fields!{field.Name}.Value");

            style = AddElement(paragraph, "Style", null);
            AddElement(style, "TextAlign", field.TextAlign);

            style = AddElement(textRun, "Style", null);
            if (field.FieldType == "System.DateTime")
            {
                AddElement(style, "Format", "dd-MMM-yyyy");
            }
            style = AddElement(textbox, "Style", null);
            border = AddElement(style, "Border", null);
            AddElement(border, "Color", "LightGrey");
            AddElement(border, "Style", "Solid");
            AddElement(style, "PaddingLeft", "2pt");
            AddElement(style, "PaddingRight", "2pt");
            AddElement(style, "PaddingTop", "2pt");
            AddElement(style, "PaddingBottom", "2pt");
        }
        private static void CreateHeaderCell(XmlElement tablixCells, XmlDocument doc, string fieldName, string fieldHeaderName)
        {
            XmlElement tablixCell;
            XmlElement cellContents;
            XmlElement textbox;
            XmlElement paragraphs;
            XmlElement paragraph;
            XmlElement textRuns;
            XmlElement textRun;
            XmlElement style;
            XmlElement border;

            tablixCell = AddElement(tablixCells, "TablixCell", null);
            cellContents = AddElement(tablixCell, "CellContents", null);
            textbox = AddElement(cellContents, "Textbox", null);
            AddAttribute(textbox, doc, "Name", $"Header{fieldName}");
            AddElement(textbox, "KeepTogether", "true");
            paragraphs = AddElement(textbox, "Paragraphs", null);
            paragraph = AddElement(paragraphs, "Paragraph", null);
            textRuns = AddElement(paragraph, "TextRuns", null);
            textRun = AddElement(textRuns, "TextRun", null);
            AddElement(textRun, "Value", $"{fieldHeaderName}");

            style = AddElement(textRun, "Style", null);
            AddElement(style, "FontWeight", "Bold");
            style = AddElement(paragraph, "Style", null);
            AddElement(style, "TextAlign", "Center");

            style = AddElement(textbox, "Style", null);
            AddElement(style, "FontWeight", "Bold");
            border = AddElement(style, "Border", null);
            AddElement(border, "Color", "LightGrey");
            AddElement(border, "Style", "Solid");
            AddElement(style, "PaddingLeft", "2pt");
            AddElement(style, "PaddingRight", "2pt");
            AddElement(style, "PaddingTop", "2pt");
            AddElement(style, "PaddingBottom", "2pt");
            //AddElement(style, "BackgroundColor", "PaleTurquoise");
            AddElement(style, "VerticalAlign", "Middle");
        }

        private static XmlElement AddElement(XmlElement parent, string name, string value)
        {
            var newelement = parent.OwnerDocument.CreateElement(name,
                "http://schemas.microsoft.com/sqlserver/reporting/2010/01/reportdefinition");
            parent.AppendChild(newelement);
            if (value != null) newelement.InnerText = value;
            return newelement;
        }
        private static XmlElement AddRdElement(XmlElement parent, string name, string value)
        {
            var newelement = parent.OwnerDocument.CreateElement(name,
                "http://schemas.microsoft.com/SQLServer/reporting/reportdesigner");
            parent.AppendChild(newelement);
            if (value != null) newelement.InnerText = value;
            return newelement;
        }
        private static XmlAttribute AddAttribute(XmlElement parentElement, XmlDocument doc, string attributeName, string attributeValue)
        {
            var attr = parentElement.Attributes.Append(doc.CreateAttribute(attributeName));
            attr.Value = attributeValue;
            return attr;
        }
    }
}
