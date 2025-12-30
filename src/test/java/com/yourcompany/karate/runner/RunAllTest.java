package com.yourcompany.karate.runner;

import com.intuit.karate.junit5.Karate;
import com.yourcompany.karate.mock.MockServerManager;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;

class RunAllTest {

    @BeforeAll
    static void beforeAll() {
        MockServerManager.start();
    }

    @AfterAll
    static void afterAll() {
        MockServerManager.stop();
    }

    @Karate.Test
    Karate runAll() {
        return Karate.run("classpath:features");
    }
}
