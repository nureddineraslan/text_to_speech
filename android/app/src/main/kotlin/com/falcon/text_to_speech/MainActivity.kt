package com.falcon.text_to_speech

import io.flutter.embedding.android.FlutterActivity
import androidx.core.app.ActivityCompat
import android.Manifest
import android.content.pm.PackageManager

class MainActivity: FlutterActivity() {
    companion object {
        private const val STORAGE_PERMISSION_REQUEST_CODE = 1000
    }

    override fun onResume() {
        super.onResume()
        checkPermissions()
    }

    private fun checkPermissions() {
        if (!isPermissionGranted(Manifest.permission.WRITE_EXTERNAL_STORAGE) ||
            !isPermissionGranted(Manifest.permission.READ_EXTERNAL_STORAGE)
        ) {
            ActivityCompat.requestPermissions(
                this,
                arrayOf(
                    Manifest.permission.WRITE_EXTERNAL_STORAGE,
                    Manifest.permission.READ_EXTERNAL_STORAGE
                ),
                STORAGE_PERMISSION_REQUEST_CODE
            )
        }
    }

    private fun isPermissionGranted(permission: String): Boolean {
        return ActivityCompat.checkSelfPermission(
            this,
            permission
        ) == PackageManager.PERMISSION_GRANTED
    }
}
