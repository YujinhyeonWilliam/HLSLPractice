using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GUIText : MonoBehaviour
{
    [SerializeField]
    private string TextForGizmo = "";

    private void OnDrawGizmos()
    {
        Texture2D texture = Resources.Load<Texture2D>("TextureForGUI");
        GUIStyle style = new GUIStyle();
        style.normal.textColor = Color.white;
        style.normal.background = texture;
        style.fontSize *= 2;

        Vector3 adjustVector = transform.right + transform.up;
        UnityEditor.Handles.Label(transform.position + adjustVector, TextForGizmo, style);
    }

}
