using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;

public class CameraPlugin : MonoBehaviour {
  [DllImport("__Internal")]
  private static extern void _StartFrontPreview();

	void Awake () {
    _StartFrontPreview();
	}

  void Update() {

  }
}
