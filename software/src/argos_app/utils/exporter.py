import os
import csv
from datetime import datetime
from typing import Dict, Any

class DatasetExporter:
    """
    Handles the real-time export of ARGOS telemetry data into CSV datasets.
    Creates a new session file upon initialization.
    """
    def __init__(self, export_dir: str = "datasets/exports"):
        self.export_dir = export_dir
        self.session_id = f"SESSION_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
        self.file_path = os.path.join(self.export_dir, f"{self.session_id}.csv")
        
        # Ensure the export directory exists
        os.makedirs(self.export_dir, exist_ok=True)
        
        # Define the exact schema columns as documented in datasets/metadata/schema.json
        self.columns = [
            "timestamp", 
            "session_id", 
            "temp_c", 
            "humidity_perc", 
            "pressure_hpa", 
            "gas_mq135_adc", 
            "distance_mm", 
            "risk_level"
        ]
        
        self._initialize_file()

    def _initialize_file(self):
        """Creates the CSV file and writes the header if it doesn't exist."""
        if not os.path.exists(self.file_path):
            with open(self.file_path, mode='w', newline='', encoding='utf-8') as f:
                writer = csv.writer(f)
                writer.writerow(self.columns)

    def log_telemetry(self, sensor_data: Dict[str, Any], risk_level: str):
        """
        Receives raw sensor dictionary and risk level, flattens it, 
        and appends a new row to the CSV dataset.
        """
        timestamp = datetime.utcnow().isoformat() + "Z"
        
        # Flatten dictionary with safe fallbacks
        row = [
            timestamp,
            self.session_id,
            sensor_data.get("temp", ""),
            sensor_data.get("humidity", ""),
            sensor_data.get("pressure", ""),
            sensor_data.get("gas", ""),
            sensor_data.get("distance", ""),
            risk_level
        ]
        
        with open(self.file_path, mode='a', newline='', encoding='utf-8') as f:
            writer = csv.writer(f)
            writer.writerow(row)
