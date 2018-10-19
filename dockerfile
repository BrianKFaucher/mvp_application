FROM microsoft/dotnet:2.1-sdk AS build 
WORKDIR /app

# copy csproj and restore as distinct layers
COPY dotnetapp/*.csproj ./dotnetapp/
COPY dotnetapp.Tests/*.csproj ./dotnetapp.Tests/
WORKDIR /app/dotnetapp
#RUN dotnet restore

# copy csproj and restore as distinct layers
COPY dotnetapp.Tests/*.csproj ./dotnetapp.Tests/
WORKDIR /app/dotnetapp.Tests
#RUN dotnet restore

# copy and publish app and libraries
WORKDIR /app/
COPY dotnetapp/. ./dotnetapp/
WORKDIR /app/dotnetapp
RUN dotnet publish -c Release -o out

WORKDIR /app/
COPY dotnetapp.Tests/. ./dotnetapp.Tests/
WORKDIR /app/dotnetapp.Tests
RUN dotnet publish -c Release -o out

FROM microsoft/dotnet:2.1-runtime AS vince 
WORKDIR /app
COPY --from=build /app/dotnetapp/out ./
COPY --from=build /app/dotnetapp.Tests/out ./Tests
ENTRYPOINT ["dotnet", "mvp_application.dll", "--urls", "http://0.0.0.0:5000"]
