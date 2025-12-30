package com.yourcompany.karate.mock;

import com.intuit.karate.core.MockServer;

public final class MockServerManager {

    private static MockServer server;
    private static int port;

    private MockServerManager() {}

    public static synchronized int start() {
        if (server != null) return port;

        // Port 0 = random free port
        server = MockServer
                .feature("classpath:mock/mock-api.feature")
                .http(0)
                .build();

        port = server.getPort();
        System.setProperty("mock.port", String.valueOf(port));
        return port;
    }

    public static synchronized void stop() {
        if (server != null) {
            server.stop();
            server = null;
        }
    }

    public static int getPort() {
        return port;
    }
}
