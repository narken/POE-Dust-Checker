#Requires Autohotkey v2
#SingleInstance force


if A_LineFile = A_ScriptFullPath && !A_IsCompiled
{
	myGui := Constructor()
	myGui.Show("w283 h260")
}

global dustfile:= Fileread("C:\Temp\poe_dust_checker\dust.csv") ; CHANGE THIS
global dust_array := StrSplit(dustfile, "`n")


Constructor()
{	
	myGui := Gui()
	myGui.Add("GroupBox", "x24 y16 w238 h200", "Dust")
	Edit1 := myGui.Add("Edit", "x90 y42 w160 h21 ReadOnly","")
	myGui.Add("Text", "x48 y42 w38 h25 +0x200", "Unique:")
	ButtonStartPost := myGui.Add("Button", "x48 y124 w80 h23", "Start")
	SB := myGui.Add("StatusBar", , "Status Bar")
	Edit2 := myGui.Add("Edit", "x90 y80 w160 h21 ReadOnly","")
	myGui.Add("Text", "x48 y82 w35 h25 +0x200", "Value:")
    ButtonStartPost.OnEvent("Click", StartStash)
	myGui.OnEvent('Close', (*) => ExitApp())
	myGui.Title := "POE Dust Checker"
	MyToolTip := myGui.Add("CheckBox", "x48 y162 w78 h25 +0x100", "ToolTip")
	MyOnTop := myGui.Add("CheckBox", "x130 y162 w78 h25 +0x100", "OnTop")
	MyOnTop.OnEvent("Click", MyOntopchange)

	MyOntopchange(*)
	{
		WinSetAlwaysOnTop -1, "POE Dust Checker"
	}

	StartStash(*)
	{
        If (ButtonStartPost.Text = "Start") {
        ButtonStartPost.Text := "Stop"
		OnClipboardChange ClipChanged
        }
        Else
		{
            ButtonStartPost.Text := "Start"
            OnClipboardChange ClipChanged, false
        }

	}

	ClipChanged(DataType) {
		If DataType = 1
		{
		word_array := StrSplit(A_Clipboard, "`n")		
		If word_array.Has(3)
            Edit1.text := word_array[3]
            Else
            return 
		oursearch := word_array[3]
		oursearch := Trim(oursearch, "`n `t") ;trim LFs and spaces/tabs
		oursearch := Trim(oursearch, "`r`n `t") ;trim CRs/LFs and spaces/tabs
		for _ in dust_array
			If inStr(_, oursearch)
			{
				Edit2.text := _
				if MyToolTip.Value=1 
					{
					ToolTip _
					;sleep(2000)
					SetTimer () => ToolTip(), -2000
					;ToolTip
					}
			}
		}
		}

	
	return myGui
}
