using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GUIText : MonoBehaviour
{
    [SerializeField]
    private string TextForGizmo = "";

    [SerializeField]
    Vector3 AdjustByCustom = Vector3.zero;

    [SerializeField]
    int FontSize = 20;

    private void OnDrawGizmos()
    {
        Texture2D texture = Resources.Load<Texture2D>("TextureForGUI");
        GUIStyle style = new GUIStyle();
        style.normal.textColor = Color.white;
        style.normal.background = texture;
        style.fontSize = FontSize;

        Vector3 adjustVector = transform.right + transform.up + AdjustByCustom;
        UnityEditor.Handles.Label(transform.position + adjustVector, TextForGizmo, style);
    }

}
