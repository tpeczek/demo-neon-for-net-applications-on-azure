using System.ComponentModel.DataAnnotations;
using Lib.AspNetCore.Mvc.JqGrid.DataAnnotations;
using Lib.AspNetCore.Mvc.JqGrid.Infrastructure.Constants;
using Lib.AspNetCore.Mvc.JqGrid.Infrastructure.Enums;

namespace Demo.AspNetCore.SimpleWebApp.Models
{
    public class StarWarsCharacterViewModel
    {
        [ScaffoldColumn(false)]
        public int Id { get; set; }

        [JqGridColumnLayout(Alignment = JqGridAlignments.Center)]
        public string Name { get; set; }

        [JqGridColumnLayout(Alignment = JqGridAlignments.Center)]
        [JqGridColumnSummary(JqGridColumnSummaryTypes.Avg)]
        public int Height { get; set; }

        [JqGridColumnLayout(Alignment = JqGridAlignments.Center)]
        [JqGridColumnSummary(JqGridColumnSummaryTypes.Avg)]
        public int? Weight { get; set; }

        [Display(Name = "Birth Year")]
        [JqGridColumnLayout(Alignment = JqGridAlignments.Center)]
        public string BirthYear { get; set; }

        [Display(Name = "First Appearance")]
        [JqGridColumnLayout(Alignment = JqGridAlignments.Center)]
        [JqGridColumnFormatter(JqGridPredefinedFormatters.Date, SourceFormat = "ISO8601Long", OutputFormat = "ISO8601Short")]
        public DateTime FirstAppearance { get; set; }
    }
}
