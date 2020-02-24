using System;
using System.Data;
using System.IO;
using System.Reflection;
using System.Windows.Forms;

namespace MMS.ClassGenerator
{
    public partial class ModelGeneratorUI : Form
    {
        public ModelGeneratorUI()
        {
            InitializeComponent();
            Height = 142;
        }

        private void btnGenerate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!ValidInformation())
                    return;
                var generator = new Generator();
                var connectionString = "Data Source=" + txtServer.Text + ";User Id= " + txtUserName.Text + ";Password =" + txtPSW.Text + ";Initial Catalog=" + txtDatabase.Text + ";Persist Security Info=False;";
                var paramInfo = new ParameterInfo
                {
                    Schema = txtSchema.Text,
                    ClassName = txtTableName.Text,
                    Query = txtTableName.Text,
                    TypeCommand = CommandType.TableDirect,
                    NameSpace = txtNamespace.Text,
                    ConnectionString = connectionString,
                    IsModel = chkModel.Checked,                    
                    IsProcedure = chkSP.Checked,
                    IsUnitTest = chkTest.Checked,
                    IsGateway = chkGateway.Checked
                };
                if (chkQuery.Checked)
                {
                    paramInfo.Query = txtQuery.Text;
                    paramInfo.TypeCommand = CommandType.Text;
                }
                generator.GenerateModel(paramInfo);
                if (chkDTO.Checked)
                {
                    paramInfo.IsModel = false;
                    paramInfo.ClassName += "Dto";
                    paramInfo.IsDTO = true;
                    generator.GenerateModel(paramInfo);
                }
                MessageBox.Show(@"Model generate completed successfully. File is located in the location : " + Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location));
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private bool ValidInformation()
        {
            if (string.IsNullOrEmpty(txtServer.Text))
            {
                MessageBox.Show(@"Server Name can't be empty", Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Information);
                txtServer.Focus();
                return false;
            }
            if (string.IsNullOrEmpty(txtDatabase.Text))
            {
                MessageBox.Show(@"Database Name can't be empty", Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Information);
                txtDatabase.Focus();
                return false;
            }
            if (string.IsNullOrEmpty(txtUserName.Text))
            {
                MessageBox.Show(@"User Name can't be empty", Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Information);
                txtUserName.Focus();
                return false;
            }
            if (string.IsNullOrEmpty(txtPSW.Text))
            {
                MessageBox.Show(@"Password can't be empty", Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Information);
                txtPSW.Focus();
                return false;
            }
            //if (string.IsNullOrEmpty(txtSchema.Text))
            //{
            //    MessageBox.Show(@"Schema can't be empty", Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Information);
            //    txtSchema.Focus();
            //    return false;
            //}
            if (string.IsNullOrEmpty(txtTableName.Text))
            {
                MessageBox.Show(@"Table Name can't be empty", Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Information);
                txtTableName.Focus();
                return false;
            }
            if (string.IsNullOrEmpty(txtNamespace.Text))
            {
                txtNamespace.Text = @"MMS.Model";
            }
            if (chkQuery.Checked && string.IsNullOrWhiteSpace(txtQuery.Text))
            {
                MessageBox.Show(@"Query can't be empty", Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Information);
                txtQuery.Focus();
                return false;
            }
            //
            return true;
        }

        private void chkQuery_CheckedChanged(object sender, EventArgs e)
        {
            txtQuery.Visible = chkQuery.Checked;
            if (chkQuery.Checked)
            {
                lblTableName.Text = @"Class Name";
                Height = 262;
            }
            else
            {
                lblTableName.Text = @"Table Name";
                Height = 142;
            }
        }
    }
}
