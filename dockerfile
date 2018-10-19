FROM microsoft/dotnet:2.1-sdk AS build 
WORKDIR /app
RUN mkdir MVP_API
RUN mkdir MVP_API.Tests

# copy csproj and restore as distinct layers
COPY MVP_API/*.csproj ./MVP_API/
COPY MVP_API.Tests/*.csproj ./MVP_API.Tests/
#WORKDIR /app/MVP_API
#RUN dotnet restore

# copy csproj and restore as distinct layers
#COPY MVP_API.Tests/*.csproj ./MVP_API.Tests/
#WORKDIR /app/MVP_API.Tests
#RUN dotnet restore

# copy and publish app and libraries
#WORKDIR /app/
#COPY MVP_API/. ./MVP_API/
WORKDIR /app/MVP_API
RUN dotnet publish -c Release -o out

#WORKDIR /app/
#COPY MVP_API.Tests/. ./MVP_API.Tests/
WORKDIR /app/MVP_API.Tests
RUN dotnet publish -c Release -o out

FROM microsoft/dotnet:2.1-runtime AS runtime 
WORKDIR /app
COPY --from=build /app/MVP_API/out ./
COPY --from=build /app/MVP_API.Tests/out ./Tests
ENTRYPOINT ["dotnet", "mvp_application.dll", "--urls", "http://0.0.0.0:5000"]
