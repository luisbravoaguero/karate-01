package com.yourcompany.karate.runner;

import com.intuit.karate.junit5.Karate;
import com.yourcompany.karate.mock.MockServerManager;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;

class RunSmokeTest {

    @BeforeAll
    static void beforeAll() {
        MockServerManager.start();
    }

    @AfterAll
    static void afterAll() {
        MockServerManager.stop();
    }

    @Karate.Test
    Karate smoke() {
        return Karate.run("classpath:features/sanity/sanity.feature");
    }
}
