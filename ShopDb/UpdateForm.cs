using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Windows.Forms.VisualStyles;

namespace ShopDb{
    public partial class UpdateForm : Form{
        public UpdateForm(){
            InitializeComponent();
        }

        private string _table;
        public UpdateForm(string table){
            InitializeComponent();
            _table = table;

            Database dbase = new Database();
            StyledDataGrid dataGrid = new StyledDataGrid();
            string command = $"select * from {table}";
            dataGrid.DataSource = dbase.Select(command);
            panel1.Controls.Add(dataGrid);

            richTextBox1.Text += "Введите условие, определяющее запись, которую вы хотите изменить.";
        }

        private string _condition;
        private void button1_Click(object sender, EventArgs e){
            switch (button1.Text){
                case "Применить условие":{

                        if (textBox1.Text == "")
                            return;
                        
                        Database dbase = new Database();

                        try{
                            this._condition = textBox1.Text;
                            string command = $"select * from {_table} where {_condition}";
                            StyledDataGrid dataDrid = new StyledDataGrid();
                            dataDrid.DataSource = dbase.Select(command);
                            button1.Text = "Изменить";
                            panel1.Controls.Clear();
                            panel1.Controls.Add(dataDrid);
                            textBox1.Text = null;
                            richTextBox1.Text = null;
                            richTextBox1.Text += "Введите название столбца, который вы хотите изменить, затем '=' и значение. Если значений много, то перечислите их через запятую.";
                        }
                        catch { MessageBox.Show("Условие введено неккоректно"); }
                        break;
                    }

                case "Изменить":{

                        if (textBox1.Text == "")
                            return;

                        string values = textBox1.Text;

                        Database dbase = new Database();

                        try{
                            string command = $"update {_table} set {values} where {_condition}";
                            dbase.Update(command);
                            this.Close();
                        }
                        catch{ MessageBox.Show("Значение или название столбца введены неверно."); }
                        
                        break;
                    }

                default: break;
            }
        }
    }
}
