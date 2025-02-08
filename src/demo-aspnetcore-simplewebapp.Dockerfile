ARG VERSION=9.0

FROM mcr.microsoft.com/dotnet/sdk:$VERSION AS build-env

WORKDIR /src

COPY Demo.AspNetCore.SimpleWebApp/*.csproj ./Demo.AspNetCore.SimpleWebApp/
COPY Demo.StartWars.EntityFrameworkCore/*.csproj ./Demo.StartWars.EntityFrameworkCore/

RUN dotnet restore Demo.AspNetCore.SimpleWebApp

COPY Demo.AspNetCore.SimpleWebApp/ ./Demo.AspNetCore.SimpleWebApp/
COPY Demo.StartWars.EntityFrameworkCore/ ./Demo.StartWars.EntityFrameworkCore/

RUN dotnet publish Demo.AspNetCore.SimpleWebApp \
  --configuration Release \
  --output /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:$VERSION
WORKDIR /app
COPY --from=build-env /app/publish .
ENV \
  DOTNET_RUNNING_IN_CONTAINER=true \
  ASPNETCORE_URLS=http://+:8080
EXPOSE 8080
ENTRYPOINT ["dotnet", "Demo.AspNetCore.SimpleWebApp.dll"]