Reproduces an issue in https://github.com/open-telemetry/opentelemetry-go

Run `./rebuild-and-run.sh` which will build the container and run it.

Trigger a request to produce a span, for example by running `curl` in a separate shell: `curl http://localhost:8080/endpoint`

Both trace provider and meter provider are configured (with a resource) in the same fashion.
The behavior is inconsistent though, the resource span includes all attributes passed in via `OTEL_RESOURCE_ATTRIBUTES`,
while the metrics do not.

(Note: `OTEL_RESOURCE_ATTRIBUTES` is set in `rebuild-and-run.sh` via `--env`.)

Output (formatted for readability):

````
{
  "Resource": [
    {
      "Key": "k8s.node.name", // <- Wrong: Only the attributes from the in-code config are here.
      "Value": {
        "Type": "STRING",
        "Value": "my-k8s-node-name"
      }
    }
  ],
  "ScopeMetrics": []
}


2024/09/03 10:16:51 incoming request

{
	"Name": "/",
	"SpanContext": {
		"TraceID": "ed66d291fb73239520059bc8ec0faf79",
		"SpanID": "5a80078b249c2ab2",
		"TraceFlags": "01",
		"TraceState": "",
		"Remote": false
	},
	"Parent": {
		"TraceID": "00000000000000000000000000000000",
		"SpanID": "0000000000000000",
		"TraceFlags": "00",
		"TraceState": "",
		"Remote": false
	},
	"SpanKind": 2,
	"StartTime": "2024-09-03T10:16:51.516961511Z",
	"EndTime": "2024-09-03T10:16:51.51789022Z",
	"Attributes": [
		{
			"Key": "http.method",
			"Value": {
				"Type": "STRING",
				"Value": "GET"
			}
		},
		{
			"Key": "http.scheme",
			"Value": {
				"Type": "STRING",
				"Value": "http"
			}
		},
		{
			"Key": "net.host.name",
			"Value": {
				"Type": "STRING",
				"Value": "localhost"
			}
		},
		{
			"Key": "net.host.port",
			"Value": {
				"Type": "INT64",
				"Value": 8080
			}
		},
		{
			"Key": "net.sock.peer.addr",
			"Value": {
				"Type": "STRING",
				"Value": "192.168.65.1"
			}
		},
		{
			"Key": "net.sock.peer.port",
			"Value": {
				"Type": "INT64",
				"Value": 24227
			}
		},
		{
			"Key": "user_agent.original",
			"Value": {
				"Type": "STRING",
				"Value": "curl/8.7.1"
			}
		},
		{
			"Key": "http.target",
			"Value": {
				"Type": "STRING",
				"Value": "/endpoint"
			}
		},
		{
			"Key": "net.protocol.version",
			"Value": {
				"Type": "STRING",
				"Value": "1.1"
			}
		},
		{
			"Key": "http.route",
			"Value": {
				"Type": "STRING",
				"Value": "/endpoint"
			}
		},
		{
			"Key": "http.response_content_length",
			"Value": {
				"Type": "INT64",
				"Value": 3
			}
		},
		{
			"Key": "http.status_code",
			"Value": {
				"Type": "INT64",
				"Value": 200
			}
		}
	],
	"Events": null,
	"Links": null,
	"Status": {
		"Code": "Unset",
		"Description": ""
	},
	"DroppedAttributes": 0,
	"DroppedEvents": 0,
	"DroppedLinks": 0,
	"ChildSpanCount": 0,
	"Resource": [             // <- Correct: The attributes from the environment variable are used here as well.
		{
			"Key": "k8s.node.name",
			"Value": {
				"Type": "STRING",
				"Value": "my-k8s-node-name"
			}
		},
		{
			"Key": "service.name",
			"Value": {
				"Type": "STRING",
				"Value": "my-service-name"
			}
		},
		{
			"Key": "service.namespace",
			"Value": {
				"Type": "STRING",
				"Value": "my-service-namespace"
			}
		},
		{
			"Key": "service.version",
			"Value": {
				"Type": "STRING",
				"Value": "1.2.3"
			}
		}
	],
	"InstrumentationScope": {
		"Name": "go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp",
		"Version": "0.54.0",
		"SchemaURL": ""
	},
	"InstrumentationLibrary": {
		"Name": "go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp",
		"Version": "0.54.0",
		"SchemaURL": ""
	}
}

{
  "Resource": [
    {
      "Key": "k8s.node.name", // <- Wrong: Only the attributes from the in-code config are here.

      "Value": {
        "Type": "STRING",
        "Value": "my-k8s-node-name"
      }
    }
  ],
  "ScopeMetrics": [
    {
      "Scope": {
        "Name": "go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp",
        "Version": "0.54.0",
        "SchemaURL": ""
      },
      "Metrics": [
        {
          "Name": "http.server.request.size",
          "Description": "Measures the size of HTTP request messages.",
          "Unit": "By",
          "Data": {
            "DataPoints": [
              {
                "Attributes": [
                  {
                    "Key": "http.method",
                    "Value": {
                      "Type": "STRING",
                      "Value": "GET"
                    }
                  },
                  {
                    "Key": "http.route",
                    "Value": {
                      "Type": "STRING",
                      "Value": "/endpoint"
                    }
                  },
                  {
                    "Key": "http.scheme",
                    "Value": {
                      "Type": "STRING",
                      "Value": "http"
                    }
                  },
                  {
                    "Key": "http.status_code",
                    "Value": {
                      "Type": "INT64",
                      "Value": 200
                    }
                  },
                  {
                    "Key": "net.host.name",
                    "Value": {
                      "Type": "STRING",
                      "Value": "localhost"
                    }
                  },
                  {
                    "Key": "net.host.port",
                    "Value": {
                      "Type": "INT64",
                      "Value": 8080
                    }
                  },
                  {
                    "Key": "net.protocol.name",
                    "Value": {
                      "Type": "STRING",
                      "Value": "http"
                    }
                  },
                  {
                    "Key": "net.protocol.version",
                    "Value": {
                      "Type": "STRING",
                      "Value": "1.1"
                    }
                  }
                ],
                "StartTime": "2024-09-03T10:16:07.528379087Z",
                "Time": "2024-09-03T10:16:52.529694553Z",
                "Value": 0
              }
            ],
            "Temporality": "CumulativeTemporality",
            "IsMonotonic": true
          }
        },
        {
          "Name": "http.server.response.size",
          "Description": "Measures the size of HTTP response messages.",
          "Unit": "By",
          "Data": {
            "DataPoints": [
              {
                "Attributes": [
                  {
                    "Key": "http.method",
                    "Value": {
                      "Type": "STRING",
                      "Value": "GET"
                    }
                  },
                  {
                    "Key": "http.route",
                    "Value": {
                      "Type": "STRING",
                      "Value": "/endpoint"
                    }
                  },
                  {
                    "Key": "http.scheme",
                    "Value": {
                      "Type": "STRING",
                      "Value": "http"
                    }
                  },
                  {
                    "Key": "http.status_code",
                    "Value": {
                      "Type": "INT64",
                      "Value": 200
                    }
                  },
                  {
                    "Key": "net.host.name",
                    "Value": {
                      "Type": "STRING",
                      "Value": "localhost"
                    }
                  },
                  {
                    "Key": "net.host.port",
                    "Value": {
                      "Type": "INT64",
                      "Value": 8080
                    }
                  },
                  {
                    "Key": "net.protocol.name",
                    "Value": {
                      "Type": "STRING",
                      "Value": "http"
                    }
                  },
                  {
                    "Key": "net.protocol.version",
                    "Value": {
                      "Type": "STRING",
                      "Value": "1.1"
                    }
                  }
                ],
                "StartTime": "2024-09-03T10:16:07.528380629Z",
                "Time": "2024-09-03T10:16:52.529797511Z",
                "Value": 3
              }
            ],
            "Temporality": "CumulativeTemporality",
            "IsMonotonic": true
          }
        },
        {
          "Name": "http.server.duration",
          "Description": "Measures the duration of inbound HTTP requests.",
          "Unit": "ms",
          "Data": {
            "DataPoints": [
              {
                "Attributes": [
                  {
                    "Key": "http.method",
                    "Value": {
                      "Type": "STRING",
                      "Value": "GET"
                    }
                  },
                  {
                    "Key": "http.route",
                    "Value": {
                      "Type": "STRING",
                      "Value": "/endpoint"
                    }
                  },
                  {
                    "Key": "http.scheme",
                    "Value": {
                      "Type": "STRING",
                      "Value": "http"
                    }
                  },
                  {
                    "Key": "http.status_code",
                    "Value": {
                      "Type": "INT64",
                      "Value": 200
                    }
                  },
                  {
                    "Key": "net.host.name",
                    "Value": {
                      "Type": "STRING",
                      "Value": "localhost"
                    }
                  },
                  {
                    "Key": "net.host.port",
                    "Value": {
                      "Type": "INT64",
                      "Value": 8080
                    }
                  },
                  {
                    "Key": "net.protocol.name",
                    "Value": {
                      "Type": "STRING",
                      "Value": "http"
                    }
                  },
                  {
                    "Key": "net.protocol.version",
                    "Value": {
                      "Type": "STRING",
                      "Value": "1.1"
                    }
                  }
                ],
                "StartTime": "2024-09-03T10:16:07.528383046Z",
                "Time": "2024-09-03T10:16:52.52979947Z",
                "Count": 1,
                "Bounds": [
                  0,
                  5,
                  10,
                  25,
                  50,
                  75,
                  100,
                  250,
                  500,
                  750,
                  1000,
                  2500,
                  5000,
                  7500,
                  10000
                ],
                "BucketCounts": [
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0
                ],
                "Min": 0.948167,
                "Max": 0.948167,
                "Sum": 0.948167
              }
            ],
            "Temporality": "CumulativeTemporality"
          }
        }
      ]
    }
  ]
}

```
