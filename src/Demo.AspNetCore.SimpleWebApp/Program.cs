using Microsoft.EntityFrameworkCore;
using Demo.StartWars.EntityFrameworkCore;
using Azure.Security.KeyVault.Secrets;
using Azure.Identity;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<StarWarsDbContext>(options =>
{
    var keyVaultSecrettClient = new SecretClient(new Uri(builder.Configuration["KEY_VAULT_URI"]), new DefaultAzureCredential());
    options.UseNpgsql(keyVaultSecrettClient.GetSecret("neon-connection-string").Value.Value);
});

builder.Services.AddControllersWithViews();

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
    pattern: "{controller=Home}/{action=Index}/{id?}")
    .WithStaticAssets();

app.Run();
