plugins {
    `java-library`
}

group = "__basepkg__"
version = "0.0.1-SNAPSHOT"

repositories {
    mavenCentral()
}

java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(__javaversion__))
    }
}

dependencies {
    api(platform("org.springframework.boot:spring-boot-dependencies:__bootversion__"))
    annotationProcessor(platform("org.springframework.boot:spring-boot-dependencies:__bootversion__"))

    compileOnly("org.projectlombok:lombok")
    annotationProcessor("org.projectlombok:lombok")
}
