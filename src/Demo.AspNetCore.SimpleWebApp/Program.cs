using Azure.Identity;
using Azure.Security.KeyVault.Secrets;
using Microsoft.EntityFrameworkCore;
using Demo.StartWars.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<StarWarsDbContext>(options =>
{
    var keyVaultSecrettClient = new SecretClient(new Uri(builder.Configuration["KEY_VAULT_URI"]), new DefaultAzureCredential());
    options.UseNpgsql(keyVaultSecrettClient.GetSecret("neon-connection-string").Value.Value);
});

builder.Services.AddControllersWithViews();

builder.Services.AddJqGrid();

var app = builder.Build();

using (var serviceScope = app.Services.GetRequiredService<IServiceScopeFactory>().CreateScope())
{
    StarWarsDbContext context = serviceScope.ServiceProvider.GetRequiredService<StarWarsDbContext>();
    context.Database.EnsureCreated();
}

app.UseHttpsRedirection();
app.UseRouting();

app.UseAuthorization();

app.MapStaticAssets();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=StarWars}/{action=Index}")
    .WithStaticAssets();

app.Run();
