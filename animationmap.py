import os
import geopandas as gpd
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
from dbfread import DBF

# Set the SHAPE_RESTORE_SHX environment variable to YES
os.environ["SHAPE_RESTORE_SHX"] = "YES"

# Step 1: Read the shapefile using GeoPandas
shapefile_path = 'Cont_AAD_CAOP2017.shp'
map_data = gpd.read_file(shapefile_path, encoding='utf-8')

# Step 2: Read the attribute data from the DBF file using dbfread
dbf_file_path = 'Cont_AAD_CAOP2017.dbf'
attribute_data = pd.DataFrame(iter(DBF(dbf_file_path, encoding='utf-8')))

# Step 3: Read the database CSV using pandas
csv_path = '3_perm_crops.csv'
database = pd.read_csv(csv_path)

# Step 4: Connect the shapefile and attribute data based on a common column
common_column = 'Freguesia'
merged_data = map_data.merge(attribute_data, on=common_column)

# Step 5: Merge with the database based on a common column
merged_data = merged_data.merge(database, left_on='Freguesia', right_on='region_name')

# Get unique crop names
crops = database['Perm_crop'].unique()

# Set up the figure and axis
fig, ax = plt.subplots(figsize=(10, 10))

# Set the frame color and label color
ax.set_facecolor('white')
ax.tick_params(colors='white')
for spine in ax.spines.values():
    spine.set_edgecolor('white')

# Function to update the plot for each frame
def update(frame):
    year = frames[frame]
    ax.clear()

    # Plot the map data without outlines
    map_data.plot(ax=ax, facecolor='lightgray', edgecolor='none')

    # Iterate over crops and plot maps
    for crop in crops:
        # Filter merged data for the specific year and crop
        year_column = f'Area_{year}'
        crop_data = merged_data[merged_data['Perm_crop'] == crop][['geometry', year_column]]

        # Plot the merged data without outlines
        crop_data.plot(ax=ax, column=year_column, cmap='coolwarm', legend=True, edgecolor='none')

    plt.title(f'Map of area in {year}')
    plt.pause(0.001)