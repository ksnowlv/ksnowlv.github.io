---
title: "Actix Web添加swagger"
date: 2024-02-02T22:02:18+08:00
lastmod: 2024-02-02T22:02:18+08:00
keywords: ["rust", "Actix Web", "后端开发"]
tags: ["rust", "Actix Web", "后端开发"]
categories: ["rust", "Actix Web", "后端开发"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## Actix Web添加swagger

### 1.添加swagger-ui配置

```toml
serde = { version = "1.0", features = ["derive"] }
serde_derive = "1.0.196"
futures = "0.3"
swagger-ui =  "0.1"
actix-files = "0.5"
actix-utils = "3.0"

[dev-dependencies]
actix-http = "3.5.0"

```

### 2.添加actix_swagger目录

---actix_swagger \
------mod.rs \
------lib.rs \
------openapi.json

* mod.rs
```rust
pub mod lib;

```

* lib.rs 



```rust
use actix_files::file_extension_to_mime;
use actix_utils::future::{ok, ready};
use actix_web::http::header::{ContentType, LOCATION};
use actix_web::web::{self, ServiceConfig};
use actix_web::{HttpRequest, HttpResponse, Route};

use swagger_ui::{Assets, Config, Spec};

const CONFIG_FILE_PATH: &str = "/swagger-ui-config.json";

/// Returns a function which configures an `App` or a `Scope` to serve the swagger-ui page displaying the given `Spec`
pub fn swagger(spec: Spec, config: Config) -> impl FnOnce(&mut ServiceConfig) {
	let mut routes: Vec<(String, Route)> = vec![];

	let config_route = config_route(config, spec.name.clone());
	routes.push(("/swagger-ui-config.json".to_owned(), config_route));

	let spec_path = spec.name.clone();
	let spec_route = spec_route(spec);
	routes.push((spec_path, spec_route));

	let index_route = index_route();
	routes.push(("".to_owned(), index_route));

	for file in Assets::iter() {
		let filename = file.as_ref();
		let content_type = content_type(filename);
		let content = Assets::get(filename).unwrap().into_owned();

		routes.push((format!("/{}", filename), body(content_type, content)));
	}

	move |c| {
		for (path, route) in routes {
			c.route(path.as_str(), route);
		}
	}
}

fn config_route(config: Config, spec_name: String) -> Route {
	web::to(move |req: HttpRequest| {
		let path = req.path().replace(CONFIG_FILE_PATH, "");
		let mut config = config.clone();
		config.url = format!("{}/{}", path, &spec_name);

		ready(HttpResponse::Ok().json(config))
	})
}

fn spec_route(spec: Spec) -> Route {
	let content_type = content_type(&spec.name);
	let content = spec.content;

	web::to(move || {
		ready(HttpResponse::Ok()
			.content_type(content_type.clone())
			.body(content.clone()))
	})
}

fn index_route() -> Route {
	web::to(|req: HttpRequest| {
		let path = req.path();

		let config_url = format!("{}{}", path, CONFIG_FILE_PATH);
		let index_url = format!("{}/index.html?configUrl={}", path, config_url);

		ready(HttpResponse::Found()
			.append_header((LOCATION, index_url))
			.finish())
	})
}

fn body(content_type: ContentType, content: Vec<u8>) -> Route {
	let handler = move || {
		ok::<_, actix_web::Error>(
			HttpResponse::Ok()
				.content_type(content_type.clone())
				.body(content.clone()),
		)
	};

	web::to(handler)
}

fn content_type(filename: impl AsRef<str>) -> ContentType {
	let mime = file_extension_to_mime(extension(filename.as_ref()));

	ContentType(mime)
}

fn extension(filename: &str) -> &str {
	if let Some(dot_index) = filename.rfind('.') {
		&filename[dot_index + 1..]
	} else {
		""
	}
}

#[cfg(test)]
mod tests {
	use std::fs;
	use actix_http::Request;
	use actix_web::{ test::{TestRequest, call_service, init_service, read_body}, web::scope, App};
	use actix_web::dev::ServiceResponse;
	use actix_web::web::Bytes;
	use swagger_ui::swagger_spec_file;

	use super::*;

	macro_rules! init_app {
        ($scope:expr) => {{
            let spec = swagger_spec_file!("openapi.json");
            let config = Config::default();
            let app = App::new()
                .service(scope($scope).configure(swagger(spec, config)));
            init_service(app).await
        }};
    }


	async fn extension_works() {
		assert_eq!("html", extension("index.html"));
		assert_eq!("js", extension("jquery.min.js"));
		assert_eq!("", extension("src"));
	}

	fn get(uri: impl AsRef<str>) -> Request {
		TestRequest::with_uri(uri.as_ref()).to_request()
	}

	fn has_location(res: &ServiceResponse, expected_location: String) -> bool {
		let location = res.headers().get(LOCATION).unwrap();

		location.eq(expected_location.as_str().into())
	}

	async fn index_redirects_with_config_url_param() {
		let prefix = "/swagger-ui";

		let mut app = init_app!(prefix);

		let res = call_service(&mut app, get(prefix)).await;
		assert!(res.status().is_redirection());
		assert!(has_location(&res, format!("{0}/index.html?configUrl={0}/swagger-ui-config.json", prefix)));

		let res = call_service(&mut app, get(format!("{}/index.html", prefix))).await;
		assert!(res.status().is_success());

		let res = call_service(&mut app, get(format!("{}/swagger-ui-config.json", prefix))).await;
		assert!(res.status().is_success());

		let res = call_service(&mut app, get(format!("{}/openapi.json", prefix))).await;

		let path = env!("CARGO_MANIFEST_DIR").to_string() + "/../swagger-ui/examples/openapi.json";
		println!("Loading {}", path);
		let expected_body = Bytes::from(fs::read(path).unwrap());

		let body = read_body(res).await;

		assert_eq!(body, expected_body);
	}
}


```

* openapi.json

```json
{
  "swagger": "2.0",
  "info": {
    "description": "This is a sample server Petstore server.  You can find out more about Swagger at [http://swagger.io](http://swagger.io) or on [irc.freenode.net, #swagger](http://swagger.io/irc/).  For this sample, you can use the api key `special-key` to test the authorization filters.",
    "version": "1.0.5",
    "title": "Swagger Petstore",
    "termsOfService": "http://swagger.io/terms/",
    "contact": {
      "email": "apiteam@swagger.io"
    },
    "license": {
      "name": "Apache 2.0",
      "url": "http://www.apache.org/licenses/LICENSE-2.0.html"
    }
  },
  "host": "petstore.swagger.io",
  "basePath": "/v2",
  "tags": [
    {
      "name": "pet",
      "description": "Everything about your Pets",
      "externalDocs": {
        "description": "Find out more",
        "url": "http://swagger.io"
      }
    },
    {
      "name": "store",
      "description": "Access to Petstore orders"
    },
    {
      "name": "user",
      "description": "Operations about user",
      "externalDocs": {
        "description": "Find out more about our store",
        "url": "http://swagger.io"
      }
    }
  ],
  "schemes": [
    "https",
    "http"
  ],
  "paths": {
    "/pet/{petId}/uploadImage": {
      "post": {
        "tags": [
          "pet"
        ],
        "summary": "uploads an image",
        "description": "",
        "operationId": "uploadFile",
        "consumes": [
          "multipart/form-data"
        ],
        "produces": [
          "application/json"
        ],
        "parameters": [
          {
            "name": "petId",
            "in": "path",
            "description": "ID of pet to update",
            "required": true,
            "type": "integer",
            "format": "int64"
          },
          {
            "name": "additionalMetadata",
            "in": "formData",
            "description": "Additional data to pass to server",
            "required": false,
            "type": "string"
          },
          {
            "name": "file",
            "in": "formData",
            "description": "file to upload",
            "required": false,
            "type": "file"
          }
        ],
        "responses": {
          "200": {
            "description": "successful operation",
            "schema": {
              "$ref": "#/definitions/ApiResponse"
            }
          }
        },
        "security": [
          {
            "petstore_auth": [
              "write:pets",
              "read:pets"
            ]
          }
        ]
      }
    },
    "/pet": {
      "post": {
        "tags": [
          "pet"
        ],
        "summary": "Add a new pet to the store",
        "description": "",
        "operationId": "addPet",
        "consumes": [
          "application/json",
          "application/xml"
        ],
        "produces": [
          "application/json",
          "application/xml"
        ],
        "parameters": [
          {
            "in": "body",
            "name": "body",
            "description": "Pet object that needs to be added to the store",
            "required": true,
            "schema": {
              "$ref": "#/definitions/Pet"
            }
          }
        ],
        "responses": {
          "405": {
            "description": "Invalid input"
          }
        },
        "security": [
          {
            "petstore_auth": [
              "write:pets",
              "read:pets"
            ]
          }
        ]
      },
      "put": {
        "tags": [
          "pet"
        ],
        "summary": "Update an existing pet",
        "description": "",
        "operationId": "updatePet",
        "consumes": [
          "application/json",
          "application/xml"
        ],
        "produces": [
          "application/json",
          "application/xml"
        ],
        "parameters": [
          {
            "in": "body",
            "name": "body",
            "description": "Pet object that needs to be added to the store",
            "required": true,
            "schema": {
              "$ref": "#/definitions/Pet"
            }
          }
        ],
        "responses": {
          "400": {
            "description": "Invalid ID supplied"
          },
          "404": {
            "description": "Pet not found"
          },
          "405": {
            "description": "Validation exception"
          }
        },
        "security": [
          {
            "petstore_auth": [
              "write:pets",
              "read:pets"
            ]
          }
        ]
      }
    },
    "/pet/findByStatus": {
      "get": {
        "tags": [
          "pet"
        ],
        "summary": "Finds Pets by status",
        "description": "Multiple status values can be provided with comma separated strings",
        "operationId": "findPetsByStatus",
        "produces": [
          "application/json",
          "application/xml"
        ],
        "parameters": [
          {
            "name": "status",
            "in": "query",
            "description": "Status values that need to be considered for filter",
            "required": true,
            "type": "array",
            "items": {
              "type": "string",
              "enum": [
                "available",
                "pending",
                "sold"
              ],
              "default": "available"
            },
            "collectionFormat": "multi"
          }
        ],
        "responses": {
          "200": {
            "description": "successful operation",
            "schema": {
              "type": "array",
              "items": {
                "$ref": "#/definitions/Pet"
              }
            }
          },
          "400": {
            "description": "Invalid status value"
          }
        },
        "security": [
          {
            "petstore_auth": [
              "write:pets",
              "read:pets"
            ]
          }
        ]
      }
    },
    "/pet/findByTags": {
      "get": {
        "tags": [
          "pet"
        ],
        "summary": "Finds Pets by tags",
        "description": "Multiple tags can be provided with comma separated strings. Use tag1, tag2, tag3 for testing.",
        "operationId": "findPetsByTags",
        "produces": [
          "application/json",
          "application/xml"
        ],
        "parameters": [
          {
            "name": "tags",
            "in": "query",
            "description": "Tags to filter by",
            "required": true,
            "type": "array",
            "items": {
              "type": "string"
            },
            "collectionFormat": "multi"
          }
        ],
        "responses": {
          "200": {
            "description": "successful operation",
            "schema": {
              "type": "array",
              "items": {
                "$ref": "#/definitions/Pet"
              }
            }
          },
          "400": {
            "description": "Invalid tag value"
          }
        },
        "security": [
          {
            "petstore_auth": [
              "write:pets",
              "read:pets"
            ]
          }
        ],
        "deprecated": true
      }
    },
    "/pet/{petId}": {
      "get": {
        "tags": [
          "pet"
        ],
        "summary": "Find pet by ID",
        "description": "Returns a single pet",
        "operationId": "getPetById",
        "produces": [
          "application/json",
          "application/xml"
        ],
        "parameters": [
          {
            "name": "petId",
            "in": "path",
            "description": "ID of pet to return",
            "required": true,
            "type": "integer",
            "format": "int64"
          }
        ],
        "responses": {
          "200": {
            "description": "successful operation",
            "schema": {
              "$ref": "#/definitions/Pet"
            }
          },
          "400": {
            "description": "Invalid ID supplied"
          },
          "404": {
            "description": "Pet not found"
          }
        },
        "security": [
          {
            "api_key": [

            ]
          }
        ]
      },
      "post": {
        "tags": [
          "pet"
        ],
        "summary": "Updates a pet in the store with form data",
        "description": "",
        "operationId": "updatePetWithForm",
        "consumes": [
          "application/x-www-form-urlencoded"
        ],
        "produces": [
          "application/json",
          "application/xml"
        ],
        "parameters": [
          {
            "name": "petId",
            "in": "path",
            "description": "ID of pet that needs to be updated",
            "required": true,
            "type": "integer",
            "format": "int64"
          },
          {
            "name": "name",
            "in": "formData",
            "description": "Updated name of the pet",
            "required": false,
            "type": "string"
          },
          {
            "name": "status",
            "in": "formData",
            "description": "Updated status of the pet",
            "required": false,
            "type": "string"
          }
        ],
        "responses": {
          "405": {
            "description": "Invalid input"
          }
        },
        "security": [
          {
            "petstore_auth": [
              "write:pets",
              "read:pets"
            ]
          }
        ]
      },
      "delete": {
        "tags": [
          "pet"
        ],
        "summary": "Deletes a pet",
        "description": "",
        "operationId": "deletePet",
        "produces": [
          "application/json",
          "application/xml"
        ],
        "parameters": [
          {
            "name": "api_key",
            "in": "header",
            "required": false,
            "type": "string"
          },
          {
            "name": "petId",
            "in": "path",
            "description": "Pet id to delete",
            "required": true,
            "type": "integer",
            "format": "int64"
          }
        ],
        "responses": {
          "400": {
            "description": "Invalid ID supplied"
          },
          "404": {
            "description": "Pet not found"
          }
        },
        "security": [
          {
            "petstore_auth": [
              "write:pets",
              "read:pets"
            ]
          }
        ]
      }
    },
    "/store/order": {
      "post": {
        "tags": [
          "store"
        ],
        "summary": "Place an order for a pet",
        "description": "",
        "operationId": "placeOrder",
        "consumes": [
          "application/json"
        ],
        "produces": [
          "application/json",
          "application/xml"
        ],
        "parameters": [
          {
            "in": "body",
            "name": "body",
            "description": "order placed for purchasing the pet",
            "required": true,
            "schema": {
              "$ref": "#/definitions/Order"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "successful operation",
            "schema": {
              "$ref": "#/definitions/Order"
            }
          },
          "400": {
            "description": "Invalid Order"
          }
        }
      }
    },
    "/store/order/{orderId}": {
      "get": {
        "tags": [
          "store"
        ],
        "summary": "Find purchase order by ID",
        "description": "For valid response try integer IDs with value >= 1 and <= 10. Other values will generated exceptions",
        "operationId": "getOrderById",
        "produces": [
          "application/json",
          "application/xml"
        ],
        "parameters": [
          {
            "name": "orderId",
            "in": "path",
            "description": "ID of pet that needs to be fetched",
            "required": true,
            "type": "integer",
            "maximum": 10,
            "minimum": 1,
            "format": "int64"
          }
        ],
        "responses": {
          "200": {
            "description": "successful operation",
            "schema": {
              "$ref": "#/definitions/Order"
            }
          },
          "400": {
            "description": "Invalid ID supplied"
          },
          "404": {
            "description": "Order not found"
          }
        }
      },
      "delete": {
        "tags": [
          "store"
        ],
        "summary": "Delete purchase order by ID",
        "description": "For valid response try integer IDs with positive integer value. Negative or non-integer values will generate API errors",
        "operationId": "deleteOrder",
        "produces": [
          "application/json",
          "application/xml"
        ],
        "parameters": [
          {
            "name": "orderId",
            "in": "path",
            "description": "ID of the order that needs to be deleted",
            "required": true,
            "type": "integer",
            "minimum": 1,
            "format": "int64"
          }
        ],
        "responses": {
          "400": {
            "description": "Invalid ID supplied"
          },
          "404": {
            "description": "Order not found"
          }
        }
      }
    },
    "/store/inventory": {
      "get": {
        "tags": [
          "store"
        ],
        "summary": "Returns pet inventories by status",
        "description": "Returns a map of status codes to quantities",
        "operationId": "getInventory",
        "produces": [
          "application/json"
        ],
        "parameters": [

        ],
        "responses": {
          "200": {
            "description": "successful operation",
            "schema": {
              "type": "object",
              "additionalProperties": {
                "type": "integer",
                "format": "int32"
              }
            }
          }
        },
        "security": [
          {
            "api_key": [

            ]
          }
        ]
      }
    },
    "/user/createWithArray": {
      "post": {
        "tags": [
          "user"
        ],
        "summary": "Creates list of users with given input array",
        "description": "",
        "operationId": "createUsersWithArrayInput",
        "consumes": [
          "application/json"
        ],
        "produces": [
          "application/json",
          "application/xml"
        ],
        "parameters": [
          {
            "in": "body",
            "name": "body",
            "description": "List of user object",
            "required": true,
            "schema": {
              "type": "array",
              "items": {
                "$ref": "#/definitions/User"
              }
            }
          }
        ],
        "responses": {
          "default": {
            "description": "successful operation"
          }
        }
      }
    },
    "/user/createWithList": {
      "post": {
        "tags": [
          "user"
        ],
        "summary": "Creates list of users with given input array",
        "description": "",
        "operationId": "createUsersWithListInput",
        "consumes": [
          "application/json"
        ],
        "produces": [
          "application/json",
          "application/xml"
        ],
        "parameters": [
          {
            "in": "body",
            "name": "body",
            "description": "List of user object",
            "required": true,
            "schema": {
              "type": "array",
              "items": {
                "$ref": "#/definitions/User"
              }
            }
          }
        ],
        "responses": {
          "default": {
            "description": "successful operation"
          }
        }
      }
    },
    "/user/{username}": {
      "get": {
        "tags": [
          "user"
        ],
        "summary": "Get user by user name",
        "description": "",
        "operationId": "getUserByName",
        "produces": [
          "application/json",
          "application/xml"
        ],
        "parameters": [
          {
            "name": "username",
            "in": "path",
            "description": "The name that needs to be fetched. Use user1 for testing. ",
            "required": true,
            "type": "string"
          }
        ],
        "responses": {
          "200": {
            "description": "successful operation",
            "schema": {
              "$ref": "#/definitions/User"
            }
          },
          "400": {
            "description": "Invalid username supplied"
          },
          "404": {
            "description": "User not found"
          }
        }
      },
      "put": {
        "tags": [
          "user"
        ],
        "summary": "Updated user",
        "description": "This can only be done by the logged in user.",
        "operationId": "updateUser",
        "consumes": [
          "application/json"
        ],
        "produces": [
          "application/json",
          "application/xml"
        ],
        "parameters": [
          {
            "name": "username",
            "in": "path",
            "description": "name that need to be updated",
            "required": true,
            "type": "string"
          },
          {
            "in": "body",
            "name": "body",
            "description": "Updated user object",
            "required": true,
            "schema": {
              "$ref": "#/definitions/User"
            }
          }
        ],
        "responses": {
          "400": {
            "description": "Invalid user supplied"
          },
          "404": {
            "description": "User not found"
          }
        }
      },
      "delete": {
        "tags": [
          "user"
        ],
        "summary": "Delete user",
        "description": "This can only be done by the logged in user.",
        "operationId": "deleteUser",
        "produces": [
          "application/json",
          "application/xml"
        ],
        "parameters": [
          {
            "name": "username",
            "in": "path",
            "description": "The name that needs to be deleted",
            "required": true,
            "type": "string"
          }
        ],
        "responses": {
          "400": {
            "description": "Invalid username supplied"
          },
          "404": {
            "description": "User not found"
          }
        }
      }
    },
    "/user/login": {
      "get": {
        "tags": [
          "user"
        ],
        "summary": "Logs user into the system",
        "description": "",
        "operationId": "loginUser",
        "produces": [
          "application/json",
          "application/xml"
        ],
        "parameters": [
          {
            "name": "username",
            "in": "query",
            "description": "The user name for login",
            "required": true,
            "type": "string"
          },
          {
            "name": "password",
            "in": "query",
            "description": "The password for login in clear text",
            "required": true,
            "type": "string"
          }
        ],
        "responses": {
          "200": {
            "description": "successful operation",
            "headers": {
              "X-Expires-After": {
                "type": "string",
                "format": "date-time",
                "description": "date in UTC when token expires"
              },
              "X-Rate-Limit": {
                "type": "integer",
                "format": "int32",
                "description": "calls per hour allowed by the user"
              }
            },
            "schema": {
              "type": "string"
            }
          },
          "400": {
            "description": "Invalid username/password supplied"
          }
        }
      }
    },
    "/user/logout": {
      "get": {
        "tags": [
          "user"
        ],
        "summary": "Logs out current logged in user session",
        "description": "",
        "operationId": "logoutUser",
        "produces": [
          "application/json",
          "application/xml"
        ],
        "parameters": [

        ],
        "responses": {
          "default": {
            "description": "successful operation"
          }
        }
      }
    },
    "/user": {
      "post": {
        "tags": [
          "user"
        ],
        "summary": "Create user",
        "description": "This can only be done by the logged in user.",
        "operationId": "createUser",
        "consumes": [
          "application/json"
        ],
        "produces": [
          "application/json",
          "application/xml"
        ],
        "parameters": [
          {
            "in": "body",
            "name": "body",
            "description": "Created user object",
            "required": true,
            "schema": {
              "$ref": "#/definitions/User"
            }
          }
        ],
        "responses": {
          "default": {
            "description": "successful operation"
          }
        }
      }
    }
  },
  "securityDefinitions": {
    "api_key": {
      "type": "apiKey",
      "name": "api_key",
      "in": "header"
    },
    "petstore_auth": {
      "type": "oauth2",
      "authorizationUrl": "https://petstore.swagger.io/oauth/authorize",
      "flow": "implicit",
      "scopes": {
        "read:pets": "read your pets",
        "write:pets": "modify pets in your account"
      }
    }
  },
  "definitions": {
    "ApiResponse": {
      "type": "object",
      "properties": {
        "code": {
          "type": "integer",
          "format": "int32"
        },
        "type": {
          "type": "string"
        },
        "message": {
          "type": "string"
        }
      }
    },
    "Category": {
      "type": "object",
      "properties": {
        "id": {
          "type": "integer",
          "format": "int64"
        },
        "name": {
          "type": "string"
        }
      },
      "xml": {
        "name": "Category"
      }
    },
    "Pet": {
      "type": "object",
      "required": [
        "name",
        "photoUrls"
      ],
      "properties": {
        "id": {
          "type": "integer",
          "format": "int64"
        },
        "category": {
          "$ref": "#/definitions/Category"
        },
        "name": {
          "type": "string",
          "example": "doggie"
        },
        "photoUrls": {
          "type": "array",
          "xml": {
            "wrapped": true
          },
          "items": {
            "type": "string",
            "xml": {
              "name": "photoUrl"
            }
          }
        },
        "tags": {
          "type": "array",
          "xml": {
            "wrapped": true
          },
          "items": {
            "xml": {
              "name": "tag"
            },
            "$ref": "#/definitions/Tag"
          }
        },
        "status": {
          "type": "string",
          "description": "pet status in the store",
          "enum": [
            "available",
            "pending",
            "sold"
          ]
        }
      },
      "xml": {
        "name": "Pet"
      }
    },
    "Tag": {
      "type": "object",
      "properties": {
        "id": {
          "type": "integer",
          "format": "int64"
        },
        "name": {
          "type": "string"
        }
      },
      "xml": {
        "name": "Tag"
      }
    },
    "Order": {
      "type": "object",
      "properties": {
        "id": {
          "type": "integer",
          "format": "int64"
        },
        "petId": {
          "type": "integer",
          "format": "int64"
        },
        "quantity": {
          "type": "integer",
          "format": "int32"
        },
        "shipDate": {
          "type": "string",
          "format": "date-time"
        },
        "status": {
          "type": "string",
          "description": "Order Status",
          "enum": [
            "placed",
            "approved",
            "delivered"
          ]
        },
        "complete": {
          "type": "boolean"
        }
      },
      "xml": {
        "name": "Order"
      }
    },
    "User": {
      "type": "object",
      "properties": {
        "id": {
          "type": "integer",
          "format": "int64"
        },
        "username": {
          "type": "string"
        },
        "firstName": {
          "type": "string"
        },
        "lastName": {
          "type": "string"
        },
        "email": {
          "type": "string"
        },
        "password": {
          "type": "string"
        },
        "phone": {
          "type": "string"
        },
        "userStatus": {
          "type": "integer",
          "format": "int32",
          "description": "User Status"
        }
      },
      "xml": {
        "name": "User"
      }
    }
  },
  "externalDocs": {
    "description": "Find out more about Swagger",
    "url": "http://swagger.io"
  }
}
```

### 3.使用

```rust
use actix_web::{web, App, HttpServer, Responder, HttpResponse};
use crate::handlers::user_handler::user_routes;
use actix_web::web::{get, scope};
mod handlers;
mod models;
mod db;
mod cache;
mod config;
mod middleware;
mod actix_swagger;

use swagger_ui;
use actix_swagger::lib::swagger;

async fn index(path: web::Path<(i32,)>) -> impl Responder {
    let value = path.0;
    HttpResponse::Ok().body(format!("Hello, Actix-web! The value is {}", value))
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {

    let http_server = HttpServer::new(|| {
        let spec = swagger_ui::swagger_spec_file!("actix_swagger/openapi.json");
        let config = swagger_ui::Config::default();

        App::new().service(scope("/api/v1/swagger")
                .configure(swagger(spec, config)))
            .configure(user_routes).route("/{value}", web::get().to(index))
    });

    http_server.bind("127.0.0.1:8084")?
    .run()
    .await
}

```

### 4.效果

服务启动后，打开http://127.0.0.1:8084/api/v1/swagger，效果如下

![image](/images/post/actix-web添加swagger/rust_swagger.png)
