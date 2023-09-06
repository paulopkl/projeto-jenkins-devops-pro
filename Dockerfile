FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 5000
EXPOSE 443

############################################################
FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY src/PedeLogo.Catalogo.Api/PedeLogo.Catalogo.Api.csproj PedeLogo.Catalogo.Api/
RUN dotnet restore "PedeLogo.Catalogo.Api/PedeLogo.Catalogo.Api.csproj"
WORKDIR /src/PedeLogo.Catalogo.Api
COPY . .
RUN dotnet build "PedeLogo.Catalogo.Api.csproj" -c Release -o /app/build

############################################################
FROM build AS publish
RUN dotnet publish "PedeLogo.Catalogo.Api.csproj" -c Release -o /app/publish

############################################################
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "PedeLogo.Catalogo.Api.dll"]
