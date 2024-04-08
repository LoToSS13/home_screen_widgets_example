// Import will depend on App ID.
package com.example.test_home_screen_widgets

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Build
import android.widget.RemoteViews
import com.example.test_home_screen_widgets.R

// New import.
import es.antonborri.home_widget.HomeWidgetPlugin
import java.io.File
import java.time.LocalDate
import java.time.format.DateTimeFormatter


/**
 * Implementation of App Widget functionality.
 */
class WeatherWidgets : AppWidgetProvider() {

    override fun onUpdate(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetIds: IntArray,
    ) {
        for (appWidgetId in appWidgetIds) {
            // Get reference to SharedPreferences
            val widgetData = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName, R.layout.weather_widgets).apply {
                
                setTextViewText(R.id.headline_title, "Последнее обновление:")

                val date = widgetData.getString("date", null)
                setTextViewText(R.id.date, date ?: "No date set")

                val cityName = widgetData.getString("city_name", null)
                setTextViewText(R.id.city_name, cityName ?: "No city name set")

                val currentWeather = widgetData.getString("current_weather", null)
                setTextViewText(R.id.current_weather, currentWeather ?: "No current weather set")

                val description = widgetData.getString("description", null)
                setTextViewText(R.id.description, description ?: "No description set")


                val imageName = widgetData.getString("filename", null)
                val imageFile = File(imageName)
                val imageExists = imageFile.exists()
                if (imageExists) {
                    val myBitmap: Bitmap = BitmapFactory.decodeFile(imageFile.absolutePath)
                    setImageViewBitmap(R.id.widget_image, myBitmap)
                } else {
                    println("image not found!, looked @: ${imageName}")
                }

            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}