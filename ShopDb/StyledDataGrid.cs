using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ShopDb{
    internal class StyledDataGrid: DataGridView {
        public StyledDataGrid(){
            Dock = DockStyle.Fill;
            BackgroundColor = Color.FromArgb(209, 204, 192);
            Font = new Font("Yu Gothic UI Ligth", 14);
            AutoSizeRowsMode = DataGridViewAutoSizeRowsMode.DisplayedCells;
            ColumnHeadersHeight = 100;
            ColumnHeadersDefaultCellStyle = new DataGridViewCellStyle() { Alignment = DataGridViewContentAlignment.MiddleCenter };
            RowsDefaultCellStyle = new DataGridViewCellStyle() { Alignment = DataGridViewContentAlignment.MiddleCenter };
            AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            AllowUserToAddRows = false;
        }
    }
}
