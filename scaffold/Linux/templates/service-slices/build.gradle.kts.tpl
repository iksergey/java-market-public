plugins {
    java
    id("org.springframework.boot") version "__bootversion__"
}

group = "__basepkg__"
version = "0.0.1-SNAPSHOT"

java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(__javaversion__))
    }
}

repositories {
    mavenCentral()
}

dependencies {
    implementation(platform("org.springframework.boot:spring-boot-dependencies:__bootversion__"))
    annotationProcessor(platform("org.springframework.boot:spring-boot-dependencies:__bootversion__"))

    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("org.springdoc:springdoc-openapi-starter-webmvc-ui:3.1.1")

    implementation("__basepkg__:common-kernel:0.0.1-SNAPSHOT")

    compileOnly("org.projectlombok:lombok")
    annotationProcessor("org.projectlombok:lombok")
}
