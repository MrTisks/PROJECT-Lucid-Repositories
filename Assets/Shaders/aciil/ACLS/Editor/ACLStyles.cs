﻿using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using System.IO;


namespace ACiiL
{
    // Base prepared by Morioh for me.
    // This code is based off synqark's arktoon-shaders and Xiexe. 
    // Citation to "https://github.com/synqark", "https://github.com/synqark/arktoon-shaders", https://gitlab.com/xMorioh/moriohs-toon-shader.

    [InitializeOnLoad]
    public class ACLStyles : MonoBehaviour
    {
        public static string ver = "ACLS-Shader v" + "<color=#ff0000ff>2.28</color>";

        private static Rect DrawShuriken(string title, Vector2 contentOffset, int HeaderHeight)
        {
            var style = new GUIStyle("ShurikenModuleTitle");
            style.font = new GUIStyle(EditorStyles.boldLabel).font;
            style.border = new RectOffset(15, 7, 4, 4);
            style.fixedHeight = HeaderHeight;
            style.contentOffset = contentOffset;
            var rect = GUILayoutUtility.GetRect(16f, HeaderHeight, style);
            GUI.Box(rect, title, style);
            return rect;
        }

        //// indent support
        private static Rect DrawShuriken(string title, Vector2 contentOffset, int HeaderHeight, int indent)
        {
            var style = new GUIStyle("ShurikenModuleTitle");
            style.font = new GUIStyle(EditorStyles.boldLabel).font;
            style.border = new RectOffset(15, 7, 4, 4);
            style.fixedHeight = HeaderHeight;
            style.contentOffset = contentOffset;
            var rect = GUILayoutUtility.GetRect(16f, HeaderHeight, style);
            rect = new Rect(rect.x + indent, rect.y, rect.width - indent, rect.height);

            // float intdentCol = Mathf.Pow(0.985f, indent);
            // Color color = new Color(intdentCol, intdentCol, intdentCol);
            // Color orgColor = GUI.backgroundColor;
            // GUI.backgroundColor = orgColor * color;
            GUI.Box(rect, title, style);
            // GUI.backgroundColor = orgColor;

            return rect;
        }

        private static Rect DrawShurikenCenteredTitle(string title, Vector2 contentOffset, int HeaderHeight)
        {
            var style = new GUIStyle("ShurikenModuleTitle");
            style.font = new GUIStyle(EditorStyles.boldLabel).font;
            style.border = new RectOffset(15, 7, 4, 4);
            style.fixedHeight = HeaderHeight;
            style.contentOffset = contentOffset;
            style.alignment = TextAnchor.MiddleCenter;
            var rect = GUILayoutUtility.GetRect(16f, HeaderHeight, style);

            GUI.Box(rect, title, style);
            return rect;
        }

        public static bool ShurikenFoldout(string title, bool display)
        {
            var rect = DrawShuriken(title, new Vector2(20f, -2f), 22);
            var e = Event.current;
            var toggleRect = new Rect(rect.x + 4f, rect.y + 2f, 13f, 13f);
            if (e.type == EventType.Repaint)
            {
                EditorStyles.foldout.Draw(toggleRect, false, false, display, false);
            }
            if (e.type == EventType.MouseDown && rect.Contains(e.mousePosition))
            {
                display = !display;
                e.Use();
            }
            return display;
        }

        //// indent support
        public static bool ShurikenFoldout(string title, bool display, int intent)
        {
            // var indentAmmount = (float)(typeof(EditorGUI).GetField("kIndentPerLevel").GetValue(null));//// reeeee it was private, WHY UNITY?
            // Debug.log("blah " + (float)(typeof(EditorGUI).GetField("kIndentPerLevel").GetValue(null)));//// appears to NULL?
            const int indentAmmount = 15;
            var rect = DrawShuriken(title, new Vector2(20f, -2f), 22, intent * indentAmmount);
            var e = Event.current;
            var toggleRect = new Rect(rect.x + 4f, rect.y + 2f, 13f, 13f); //// the arrow
            if (e.type == EventType.Repaint)
            {
                EditorStyles.foldout.Draw(toggleRect, false, false, display, false);
            }
            if (e.type == EventType.MouseDown && rect.Contains(e.mousePosition))
            {
                display = !display;
                e.Use();
            }
            return display;
        }

        //parting line text
        private static Rect DrawShurikenPartingLineText(string title, Vector2 contentOffset, int HeaderHeight)
        {
            var style = new GUIStyle("ShurikenModuleTitle");
            style.font = new GUIStyle(EditorStyles.boldLabel).font;
            style.border = new RectOffset(15, 7, 4, 4);
            style.fixedHeight = HeaderHeight;
            style.contentOffset = contentOffset;
            style.alignment = TextAnchor.MiddleCenter;
            var rect = GUILayoutUtility.GetRect(16f, HeaderHeight, style);

            GUI.Box(rect, title, style);
            return rect;
        }
        //end of parting line text

        //parting lines
        static public void PartingLine()
        {
            GUILayout.Space(5);
            GUILine(new Color(1f, 1f, 1f), 1.5f);
            GUILayout.Space(5);
        }

        static public void GUILine(float height = 0f)
        {
            GUILine(Color.black, height);
        }

        static public void GUILine(Color color, float height = 0f)
        {
            Rect position = GUILayoutUtility.GetRect(0f, float.MaxValue, height, height, LineStyle);

            if (Event.current.type == EventType.Repaint)
            {
                Color orgColor = GUI.color;
                GUI.color = orgColor * color;
                LineStyle.Draw(position, false, false, false, false);
                GUI.color = orgColor;
            }
        }

        static public GUIStyle _LineStyle;
        static public GUIStyle LineStyle
        {
            get
            {
                if (_LineStyle == null)
                {
                    _LineStyle = new GUIStyle();
                    _LineStyle.normal.background = EditorGUIUtility.whiteTexture;
                    _LineStyle.stretchWidth = true;
                }

                return _LineStyle;
            }
        }
        // end of parting line

        //// MeroFune, 3.
        static void UpdateDepreciatedProperty(Material targetMat, string oldPropertyName, string newPropertyName, MaterialProperty.PropType propType)
        {
            if (targetMat.HasProperty(oldPropertyName))
            {
                // float
                if (propType == MaterialProperty.PropType.Float)
                {
                    targetMat.SetFloat(newPropertyName, targetMat.GetFloat(oldPropertyName));
                }

                // vector float - Note: 3 says this should handle colours too
                if (propType == MaterialProperty.PropType.Color || propType == MaterialProperty.PropType.Vector)
                {
                    targetMat.SetVectorArray(newPropertyName, targetMat.GetVectorArray(oldPropertyName));
                }

                // texture
                if (propType == MaterialProperty.PropType.Texture)
                {
                    targetMat.SetTexture(newPropertyName, targetMat.GetTexture(oldPropertyName));
                }
            }
        }

        //// Shader Presets 
        static void DoPresetNPR(Material targetMat)
        {
            Undo.RegisterCompleteObjectUndo(targetMat, "Material");
            targetMat.SetColor("_Color", new Color(1f, 0f, 0f, 1f));
        }

        /*
            Called by inspector to update any depreciated ACLS properties
            Call `UpdateDepreciatedProperty()` for each one and add it to this method.
            Slap it in the constructor or smth, to avoid being called on redraw
        */
        public static void UpdateDepreciatedProperties(Material targetMat)
        {
            // UpdateDepreciatedProperty(targetMat, "_0_ShaderColor", "_BaseColor", MaterialProperty.PropType.Color)
        }

        // get width if current draw
        // https://forum.unity.com/threads/editorguilayout-get-width-of-inspector-window-area.82068/
        private static Rect _rect;
        public static float GetViewWidth()
        {
            GUILayout.Label("hack", GUILayout.MaxHeight(0));
            if (Event.current.type == EventType.Repaint)
            {
                // hack to get real view width
                _rect = GUILayoutUtility.GetLastRect();
            }

            return _rect.width;
        }



        //extra buttons
        public static void gitVersionCheckButton(int Width, int Height)
        {
            if (GUILayout.Button("Check Version", GUILayout.Width(Width), GUILayout.Height(Height)))
            {
                Application.OpenURL("https://aciil.booth.pm/items/1779615");
            }
        }

        public static void gitSourcebutton(int Width, int Height)
        {
            if (GUILayout.Button("Get Source", GUILayout.Width(Width), GUILayout.Height(Height)))
            {
                Application.OpenURL("https://github.com/ACIIL/ACLS-Shader/");
            }
        }

        public static void wikiButton(int Width, int Height)
        {
            if (GUILayout.Button("Show Wiki", GUILayout.Width(Width), GUILayout.Height(Height)))
            {
                Application.OpenURL("https://github.com/ACIIL/ACLS-Shader/wiki");
            }
        }

        public static void socialButton(int Width, int Height)
        {
            if (GUILayout.Button("Social", GUILayout.Width(Width), GUILayout.Height(Height)))
            {
                Application.OpenURL("https://github.com/ACIIL/ACLS-Shader/wiki/Links");
            }
        }

        public static void ShurikenHeader(string title)
        {
            DrawShuriken(title, new Vector2(6f, -2f), 22);
        }

        public static void ShurikenHeaderCentered(string title)
        {
            DrawShurikenCenteredTitle(title, new Vector2(0f, -2f), 22);
        }

        public static void DrawShurikenPartingLineText(string title)
        {
            DrawShurikenPartingLineText(title, new Vector2(6f, -2f), 22);
        }

        public static void DoPreset(int Width, int Height, Material targetMat)
        {
            if (GUILayout.Button("Preset 1", GUILayout.Width(Width), GUILayout.Height(Height)))
            {
                DoPresetNPR(targetMat);
            }
        }

        public static void DrawButtons(Material targetMat)
        {
            ACLStyles.PartingLine();
            EditorGUILayout.BeginHorizontal();
            GUILayout.FlexibleSpace();
            ACLStyles.gitVersionCheckButton(100, 30);
            ACLStyles.gitSourcebutton(100, 30);
            GUILayout.FlexibleSpace();
            EditorGUILayout.EndHorizontal();
            EditorGUILayout.BeginHorizontal();
            GUILayout.FlexibleSpace();
            ACLStyles.wikiButton(100, 30);
            ACLStyles.socialButton(100, 30);
            GUILayout.FlexibleSpace();
            EditorGUILayout.EndHorizontal();

            // EditorGUILayout.BeginHorizontal();
            // GUILayout.FlexibleSpace();
            // ACLStyles.DoPreset(100, 30, targetMat);
            // GUILayout.FlexibleSpace();
            // EditorGUILayout.EndHorizontal();
        }

    }
}