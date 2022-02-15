FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 as build-env
WORKDIR /app
EXPOSE 80
COPY ./ ./

RUN msbuild ./AppModelv2-WebApp-OpenIDConnect-DotNet/AppModelv2-WebApp-OpenIDConnect-DotNet.csproj /p:OutDir=/app/out /p:Configuration="release" /p:GenerateProjectSpecificOutputFolder=true /p:UseWPP_CopyWebApplication=true /p:PipelineDependsOnBuild=false

#RUN Set-WebConfiguration //System.WebServer/Security/Authentication/anonymousAuthenticaiton -metadata overrideMode -value Allow -PSPath IIS:/

FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2019
ARG source
WORKDIR /inetpub/wwwroot
COPY --from=build-env /app/out/AppModelv2-WebApp-OpenIDConnect-DotNet/_PublishedWebsites/AppModelv2-WebApp-OpenIDConnect-DotNet ./