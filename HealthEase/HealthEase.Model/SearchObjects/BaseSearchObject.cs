using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.SearchObjects
{
    public class BaseSearchObject
    {
        public int? Page { get; set; }
        public int? PageSize { get; set; }
        public bool? RetrieveAll { get; set; }
        /// <summary>
        /// Pass specific attribute from database model with fullname
        /// </summary>
        public string? OrderBy { get; set; }
        /// <summary>
        /// Pass values asc, ascending, desc or descending
        /// </summary>
        public string? SortDirection { get; set; }
        /// <summary>
        /// Pass tables to include with comma: table2, table3 ..
        /// </summary>
        public string? IncludeTables { get; set; }
    }

}
