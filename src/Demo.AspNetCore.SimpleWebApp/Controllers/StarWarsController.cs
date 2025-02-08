using Demo.StartWars.EntityFrameworkCore;
using Lib.AspNetCore.Mvc.JqGrid.Core.Request;
using Lib.AspNetCore.Mvc.JqGrid.Core.Response;
using Lib.AspNetCore.Mvc.JqGrid.Core.Results;
using Lib.AspNetCore.Mvc.JqGrid.Infrastructure.Enums;
using Microsoft.AspNetCore.Mvc;
using System.Globalization;

namespace Demo.AspNetCore.SimpleWebApp.Controllers
{
    public class StarWarsController : Controller
    {
        private readonly StarWarsDbContext _starWarsDbContext;

        public StarWarsController(StarWarsDbContext starWarsDbContext)
        {
            _starWarsDbContext = starWarsDbContext;
        }

        public IActionResult Index()
        {
            return View();
        }

        [HttpPost()]
        public IActionResult Characters(JqGridRequest request)
        {
            IQueryable<Character> charactersQueryable = _starWarsDbContext.Characters;

            int totalRecords = charactersQueryable.Count();

            JqGridResponse response = new JqGridResponse()
            {
                TotalPagesCount = (int)Math.Ceiling((float)totalRecords / (float)request.RecordsCount),
                PageIndex = request.PageIndex,
                TotalRecordsCount = totalRecords,
                UserData = new
                {
                    Name = "Averages:",
                    Height = _starWarsDbContext.Characters.Average(character => character.Height),
                    Weight = _starWarsDbContext.Characters.Average(character => character.Weight)
                }
            };

            charactersQueryable = SortCharacters(charactersQueryable, request.SortingName, request.SortingOrder);

            foreach (Character character in charactersQueryable.Skip(request.PageIndex * request.RecordsCount).Take(request.PagesCount * request.RecordsCount))
            {
                response.Records.Add(new JqGridRecord(Convert.ToString(character.Id), character));
            }

            response.Reader.RepeatItems = false;

            return new JqGridJsonResult(response);
        }

        private static IQueryable<Character> SortCharacters(IQueryable<Character> charactersQueryable, string sortingDefition, JqGridSortingOrders sortingOrder)
        {
            IOrderedEnumerable<Character> orderedCharacters = null;

            if (!String.IsNullOrWhiteSpace(sortingDefition))
            {
                sortingDefition = sortingDefition.ToLowerInvariant();

                string[] subSortingDefinitions = sortingDefition.Split(',');
                foreach (string subSortingDefinition in subSortingDefinitions)
                {
                    string[] sortingDetails = subSortingDefinition.Trim().Split(' ');
                    string sortingDetailsName = sortingDetails[0];
                    JqGridSortingOrders sortingDetailsOrder = (sortingDetails.Length > 1) ? (JqGridSortingOrders)Enum.Parse(typeof(JqGridSortingOrders), sortingDetails[1], true) : sortingOrder;

                    Func<Character, object> sortingExpression = GetCharacterSortingExpression(sortingDetailsName, sortingDetailsOrder);

                    if (sortingExpression != null)
                    {
                        if (orderedCharacters != null)
                        {
                            orderedCharacters = (sortingDetailsOrder == JqGridSortingOrders.Asc) ? orderedCharacters.ThenBy(sortingExpression) : orderedCharacters.ThenByDescending(sortingExpression);
                        }
                        else
                        {
                            orderedCharacters = (sortingDetailsOrder == JqGridSortingOrders.Asc) ? charactersQueryable.OrderBy(sortingExpression) : charactersQueryable.OrderByDescending(sortingExpression);
                        }

                    }
                }
            }

            return orderedCharacters.AsQueryable();
        }

        private static Func<Character, object> GetCharacterSortingExpression(string sortingName, JqGridSortingOrders sortingOrder)
        {
            Func<Character, object> sortingExpression = null;

            switch (sortingName)
            {
                case "id":
                    sortingExpression = (character => character.Id);
                    break;
                case "name":
                    sortingExpression = (character => character.Name);
                    break;
                case "height":
                    sortingExpression = (character => character.Height);
                    break;
                case "weight":
                    sortingExpression = (character => character.Weight ?? ((sortingOrder == JqGridSortingOrders.Asc) ? Int32.MaxValue : Int32.MinValue));
                    break;
                case "birthyear":
                    sortingExpression = (character => {
                        decimal birthYear = (sortingOrder == JqGridSortingOrders.Asc) ? Int32.MaxValue : Int32.MinValue;

                        if (!String.IsNullOrWhiteSpace(character.BirthYear))
                        {
                            if (character.BirthYear.EndsWith("BBY", StringComparison.OrdinalIgnoreCase))
                            {
                                birthYear = (-1) * Convert.ToDecimal(character.BirthYear.Substring(0, character.BirthYear.Length - 3), CultureInfo.InvariantCulture);
                            }
                            else if (character.BirthYear.EndsWith("ABY", StringComparison.OrdinalIgnoreCase))
                            {
                                birthYear = Convert.ToDecimal(character.BirthYear.Substring(0, character.BirthYear.Length - 3), CultureInfo.InvariantCulture);
                            }
                        }

                        return birthYear;
                    });
                    break;
                case "firstappearance":
                    sortingExpression = (character => character.FirstAppearance);
                    break;
                default:
                    break;
            }

            return sortingExpression;
        }
    }
}
