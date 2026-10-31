plugins {
    id("org.gradle.toolchains.foojay-resolver-convention") version "1.0.0"
}

rootProject.name = "__name__"

include("__name__-domain", "__name__-application", "__name__-infrastructure", "__name__-api")
