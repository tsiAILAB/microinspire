namespace MMS.ClassGenerator
{
    partial class ModelGeneratorUI
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.grpInfo = new System.Windows.Forms.GroupBox();
            this.chkDTO = new System.Windows.Forms.CheckBox();
            this.txtSchema = new System.Windows.Forms.TextBox();
            this.lblSchema = new System.Windows.Forms.Label();
            this.chkGateway = new System.Windows.Forms.CheckBox();
            this.chkTest = new System.Windows.Forms.CheckBox();
            this.chkSP = new System.Windows.Forms.CheckBox();
            this.chkModel = new System.Windows.Forms.CheckBox();
            this.chkQuery = new System.Windows.Forms.CheckBox();
            this.txtNamespace = new System.Windows.Forms.TextBox();
            this.lblNamespace = new System.Windows.Forms.Label();
            this.txtTableName = new System.Windows.Forms.TextBox();
            this.txtPSW = new System.Windows.Forms.TextBox();
            this.txtUserName = new System.Windows.Forms.TextBox();
            this.txtDatabase = new System.Windows.Forms.TextBox();
            this.lblTableName = new System.Windows.Forms.Label();
            this.lblPSW = new System.Windows.Forms.Label();
            this.lblUserName = new System.Windows.Forms.Label();
            this.lblDatabase = new System.Windows.Forms.Label();
            this.lblServer = new System.Windows.Forms.Label();
            this.txtServer = new System.Windows.Forms.TextBox();
            this.btnGenerate = new System.Windows.Forms.Button();
            this.txtQuery = new System.Windows.Forms.RichTextBox();
            this.grpInfo.SuspendLayout();
            this.SuspendLayout();
            // 
            // grpInfo
            // 
            this.grpInfo.Controls.Add(this.chkDTO);
            this.grpInfo.Controls.Add(this.txtSchema);
            this.grpInfo.Controls.Add(this.lblSchema);
            this.grpInfo.Controls.Add(this.chkGateway);
            this.grpInfo.Controls.Add(this.chkTest);
            this.grpInfo.Controls.Add(this.chkSP);
            this.grpInfo.Controls.Add(this.chkModel);
            this.grpInfo.Controls.Add(this.chkQuery);
            this.grpInfo.Controls.Add(this.txtNamespace);
            this.grpInfo.Controls.Add(this.lblNamespace);
            this.grpInfo.Controls.Add(this.txtTableName);
            this.grpInfo.Controls.Add(this.txtPSW);
            this.grpInfo.Controls.Add(this.txtUserName);
            this.grpInfo.Controls.Add(this.txtDatabase);
            this.grpInfo.Controls.Add(this.lblTableName);
            this.grpInfo.Controls.Add(this.lblPSW);
            this.grpInfo.Controls.Add(this.lblUserName);
            this.grpInfo.Controls.Add(this.lblDatabase);
            this.grpInfo.Controls.Add(this.lblServer);
            this.grpInfo.Controls.Add(this.txtServer);
            this.grpInfo.Controls.Add(this.btnGenerate);
            this.grpInfo.Location = new System.Drawing.Point(11, 12);
            this.grpInfo.Name = "grpInfo";
            this.grpInfo.Size = new System.Drawing.Size(899, 84);
            this.grpInfo.TabIndex = 8;
            this.grpInfo.TabStop = false;
            // 
            // chkDTO
            // 
            this.chkDTO.AutoSize = true;
            this.chkDTO.Checked = true;
            this.chkDTO.CheckState = System.Windows.Forms.CheckState.Checked;
            this.chkDTO.Location = new System.Drawing.Point(186, 56);
            this.chkDTO.Name = "chkDTO";
            this.chkDTO.Size = new System.Drawing.Size(102, 17);
            this.chkDTO.TabIndex = 19;
            this.chkDTO.Text = "Generate DTO?";
            this.chkDTO.UseVisualStyleBackColor = true;
            // 
            // txtSchema
            // 
            this.txtSchema.Location = new System.Drawing.Point(560, 32);
            this.txtSchema.Name = "txtSchema";
            this.txtSchema.Size = new System.Drawing.Size(60, 20);
            this.txtSchema.TabIndex = 5;
            this.txtSchema.Text = "dbo";
            // 
            // lblSchema
            // 
            this.lblSchema.AutoSize = true;
            this.lblSchema.Location = new System.Drawing.Point(557, 16);
            this.lblSchema.Name = "lblSchema";
            this.lblSchema.Size = new System.Drawing.Size(46, 13);
            this.lblSchema.TabIndex = 18;
            this.lblSchema.Text = "Schema";
            // 
            // chkGateway
            // 
            this.chkGateway.AutoSize = true;
            this.chkGateway.Location = new System.Drawing.Point(569, 56);
            this.chkGateway.Name = "chkGateway";
            this.chkGateway.Size = new System.Drawing.Size(121, 17);
            this.chkGateway.TabIndex = 16;
            this.chkGateway.Text = "Generate Gateway?";
            this.chkGateway.UseVisualStyleBackColor = true;
            this.chkGateway.Visible = false;
            // 
            // chkTest
            // 
            this.chkTest.AutoSize = true;
            this.chkTest.Location = new System.Drawing.Point(440, 57);
            this.chkTest.Name = "chkTest";
            this.chkTest.Size = new System.Drawing.Size(122, 17);
            this.chkTest.TabIndex = 15;
            this.chkTest.Text = "Generate Unit Test?";
            this.chkTest.UseVisualStyleBackColor = true;
            this.chkTest.Visible = false;
            // 
            // chkSP
            // 
            this.chkSP.AutoSize = true;
            this.chkSP.Location = new System.Drawing.Point(303, 56);
            this.chkSP.Name = "chkSP";
            this.chkSP.Size = new System.Drawing.Size(128, 17);
            this.chkSP.TabIndex = 14;
            this.chkSP.Text = "Generate Procedure?";
            this.chkSP.UseVisualStyleBackColor = true;
            this.chkSP.Visible = false;
            // 
            // chkModel
            // 
            this.chkModel.AutoSize = true;
            this.chkModel.Checked = true;
            this.chkModel.CheckState = System.Windows.Forms.CheckState.Checked;
            this.chkModel.Location = new System.Drawing.Point(73, 56);
            this.chkModel.Name = "chkModel";
            this.chkModel.Size = new System.Drawing.Size(105, 17);
            this.chkModel.TabIndex = 13;
            this.chkModel.Text = "Generate Entity?";
            this.chkModel.UseVisualStyleBackColor = true;
            // 
            // chkQuery
            // 
            this.chkQuery.AutoSize = true;
            this.chkQuery.Location = new System.Drawing.Point(8, 56);
            this.chkQuery.Name = "chkQuery";
            this.chkQuery.Size = new System.Drawing.Size(54, 17);
            this.chkQuery.TabIndex = 12;
            this.chkQuery.Text = "Query";
            this.chkQuery.UseVisualStyleBackColor = true;
            this.chkQuery.CheckedChanged += new System.EventHandler(this.chkQuery_CheckedChanged);
            // 
            // txtNamespace
            // 
            this.txtNamespace.Location = new System.Drawing.Point(397, 32);
            this.txtNamespace.Name = "txtNamespace";
            this.txtNamespace.Size = new System.Drawing.Size(157, 20);
            this.txtNamespace.TabIndex = 4;
            this.txtNamespace.Text = "MMS.DAL";
            // 
            // lblNamespace
            // 
            this.lblNamespace.AutoSize = true;
            this.lblNamespace.Location = new System.Drawing.Point(397, 16);
            this.lblNamespace.Name = "lblNamespace";
            this.lblNamespace.Size = new System.Drawing.Size(64, 13);
            this.lblNamespace.TabIndex = 11;
            this.lblNamespace.Text = "Namespace";
            // 
            // txtTableName
            // 
            this.txtTableName.Location = new System.Drawing.Point(626, 32);
            this.txtTableName.Name = "txtTableName";
            this.txtTableName.Size = new System.Drawing.Size(186, 20);
            this.txtTableName.TabIndex = 6;
            // 
            // txtPSW
            // 
            this.txtPSW.Location = new System.Drawing.Point(320, 31);
            this.txtPSW.Name = "txtPSW";
            this.txtPSW.PasswordChar = '*';
            this.txtPSW.Size = new System.Drawing.Size(74, 20);
            this.txtPSW.TabIndex = 3;
            this.txtPSW.Text = "unlock";
            // 
            // txtUserName
            // 
            this.txtUserName.Location = new System.Drawing.Point(234, 31);
            this.txtUserName.Name = "txtUserName";
            this.txtUserName.Size = new System.Drawing.Size(84, 20);
            this.txtUserName.TabIndex = 2;
            this.txtUserName.Text = "sa";
            // 
            // txtDatabase
            // 
            this.txtDatabase.Location = new System.Drawing.Point(123, 31);
            this.txtDatabase.Name = "txtDatabase";
            this.txtDatabase.Size = new System.Drawing.Size(107, 20);
            this.txtDatabase.TabIndex = 1;
            this.txtDatabase.Text = "MMS";
            // 
            // lblTableName
            // 
            this.lblTableName.AutoSize = true;
            this.lblTableName.Location = new System.Drawing.Point(623, 16);
            this.lblTableName.Name = "lblTableName";
            this.lblTableName.Size = new System.Drawing.Size(65, 13);
            this.lblTableName.TabIndex = 9;
            this.lblTableName.Text = "Table Name";
            // 
            // lblPSW
            // 
            this.lblPSW.AutoSize = true;
            this.lblPSW.Location = new System.Drawing.Point(320, 15);
            this.lblPSW.Name = "lblPSW";
            this.lblPSW.Size = new System.Drawing.Size(53, 13);
            this.lblPSW.TabIndex = 8;
            this.lblPSW.Text = "Password";
            // 
            // lblUserName
            // 
            this.lblUserName.AutoSize = true;
            this.lblUserName.Location = new System.Drawing.Point(234, 15);
            this.lblUserName.Name = "lblUserName";
            this.lblUserName.Size = new System.Drawing.Size(60, 13);
            this.lblUserName.TabIndex = 7;
            this.lblUserName.Text = "User Name";
            // 
            // lblDatabase
            // 
            this.lblDatabase.AutoSize = true;
            this.lblDatabase.Location = new System.Drawing.Point(123, 15);
            this.lblDatabase.Name = "lblDatabase";
            this.lblDatabase.Size = new System.Drawing.Size(84, 13);
            this.lblDatabase.TabIndex = 6;
            this.lblDatabase.Text = "Database Name";
            // 
            // lblServer
            // 
            this.lblServer.AutoSize = true;
            this.lblServer.Location = new System.Drawing.Point(8, 15);
            this.lblServer.Name = "lblServer";
            this.lblServer.Size = new System.Drawing.Size(69, 13);
            this.lblServer.TabIndex = 5;
            this.lblServer.Text = "Server Name";
            // 
            // txtServer
            // 
            this.txtServer.Location = new System.Drawing.Point(8, 31);
            this.txtServer.Name = "txtServer";
            this.txtServer.Size = new System.Drawing.Size(113, 20);
            this.txtServer.TabIndex = 0;
            this.txtServer.Text = "MAMUN-PC";
            // 
            // btnGenerate
            // 
            this.btnGenerate.Location = new System.Drawing.Point(818, 31);
            this.btnGenerate.Name = "btnGenerate";
            this.btnGenerate.Size = new System.Drawing.Size(75, 22);
            this.btnGenerate.TabIndex = 6;
            this.btnGenerate.Text = "Generate";
            this.btnGenerate.Click += new System.EventHandler(this.btnGenerate_Click);
            // 
            // txtQuery
            // 
            this.txtQuery.AcceptsTab = true;
            this.txtQuery.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.txtQuery.Location = new System.Drawing.Point(12, 102);
            this.txtQuery.Name = "txtQuery";
            this.txtQuery.Size = new System.Drawing.Size(899, 110);
            this.txtQuery.TabIndex = 9;
            this.txtQuery.Text = "";
            this.txtQuery.Visible = false;
            // 
            // ModelGeneratorUI
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(922, 224);
            this.Controls.Add(this.txtQuery);
            this.Controls.Add(this.grpInfo);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.Name = "ModelGeneratorUI";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Model Generator";
            this.grpInfo.ResumeLayout(false);
            this.grpInfo.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.GroupBox grpInfo;
        private System.Windows.Forms.TextBox txtTableName;
        private System.Windows.Forms.TextBox txtPSW;
        private System.Windows.Forms.TextBox txtUserName;
        private System.Windows.Forms.TextBox txtDatabase;
        private System.Windows.Forms.Label lblTableName;
        private System.Windows.Forms.Label lblPSW;
        private System.Windows.Forms.Label lblUserName;
        private System.Windows.Forms.Label lblDatabase;
        private System.Windows.Forms.Label lblServer;
        private System.Windows.Forms.TextBox txtServer;
        private System.Windows.Forms.Button btnGenerate;
        private System.Windows.Forms.RichTextBox txtQuery;
        private System.Windows.Forms.TextBox txtNamespace;
        private System.Windows.Forms.Label lblNamespace;
        private System.Windows.Forms.CheckBox chkQuery;
        private System.Windows.Forms.CheckBox chkTest;
        private System.Windows.Forms.CheckBox chkSP;
        private System.Windows.Forms.CheckBox chkModel;
        private System.Windows.Forms.CheckBox chkGateway;
        private System.Windows.Forms.TextBox txtSchema;
        private System.Windows.Forms.Label lblSchema;
        private System.Windows.Forms.CheckBox chkDTO;
    }
}

