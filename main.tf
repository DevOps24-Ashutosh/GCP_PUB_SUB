# Configure the Google Cloud provider
provider "google" {
  project = "terraform-pub-sub"  # Replace with your project ID
  region  = "us-central1"
  # credentials = "/home/ubuntu/gcp.json"
}

# Create a Pub/Sub schema
resource "google_pubsub_schema" "message_schema_3" {
  name = "message-schema-3"
  type = "AVRO"
  definition = jsonencode({
    type = "record"
    name = "Message"
    fields = [
      {
        name = "content"
        type = "string"
      },
      {
        name = "timestamp"
        type = "string"
      }
    ]
  })
}

# Create a Pub/Sub topic with the schema
resource "google_pubsub_topic" "example_topic_3" {
  name = "example-topic-3"

  schema_settings {
    schema   = google_pubsub_schema.message_schema_3.id
    encoding = "JSON"
  }
}

# Create a BigQuery dataset
resource "google_bigquery_dataset" "example_dataset_3" {
  dataset_id = "example_dataset_3"
  location   = "US"
}

# Create a BigQuery table with required metadata columns
resource "google_bigquery_table" "example_table_3" {
  dataset_id          = google_bigquery_dataset.example_dataset_3.dataset_id
  table_id            = "example_table_3"
  deletion_protection = false

  schema = <<EOF
[
  {
    "name": "subscription_name",
    "type": "STRING",
    "mode": "REQUIRED",
    "description": "Pub/Sub subscription name"
  },
  {
    "name": "message_id",
    "type": "STRING",
    "mode": "REQUIRED",
    "description": "Pub/Sub message ID"
  },
  {
    "name": "content",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "timestamp",
    "type": "TIMESTAMP",
    "mode": "REQUIRED"
  },
  {
    "name": "publish_time",
    "type": "TIMESTAMP",
    "mode": "REQUIRED",
    "description": "Pub/Sub message publish time"
  },
  {
    "name": "attributes",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "Pub/Sub message attributes"
  }
]
EOF
}

# Create a Pub/Sub subscription to BigQuery
resource "google_pubsub_subscription" "bigquery_subscription_3" {
  name  = "example-bigquery-subscription-3"
  topic = google_pubsub_topic.example_topic_3.name

  bigquery_config {
    table            = "${google_bigquery_table.example_table_3.project}.${google_bigquery_table.example_table_3.dataset_id}.${google_bigquery_table.example_table_3.table_id}"
    use_topic_schema = true
    write_metadata   = true
  }
}