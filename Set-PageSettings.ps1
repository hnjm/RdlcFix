Write-Host -f DarkYellow "Be Carefull, make sure you have a backup of the DebtorStatement.rdlc!"

Write-Host "Press any key to continue ..."
#$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

$filename = "DebtorStatement.rdlc"
$rdlc = [xml](gc $filename )

$curr = @"
Page 
    Width : {0}
    Height: {1}
Margins
    Left:   {2}
    Right:  {3}
    Top:    {4}
    Bottom: {5}
"@

$origPageWidth = $rdlc.Report.Page.PageWidth
$origPageHeight = $rdlc.Report.Page.PageHeight
$origLeftMargin = $rdlc.Report.Page.LeftMargin
$origRightMargin = $rdlc.Report.Page.RightMargin
$origTopMargin = $rdlc.Report.Page.TopMargin
$origBottomMargin = $rdlc.Report.Page.BottomMargin

Write-Host "Current Settings:"
Write-Host ($curr -f $origPageWidth, $origPageHeight,
    ` $origLeftMargin, $origRightMargin, $origTopMargin, $origBottomMargin)

$confirmation = Read-Host "Do you want to change these settings (y|n)?"
if ($confirmation -eq 'y') {
    write-host "Press Enter to keep defaults, there is no input validation - type new value exactly same (with unit)"
    #$rdlc.Report.Page.PageWidth

    $newPageWidth    = [string] (Read-Host "Page Width    ($origPageWidth)")
    $newPageHeight   = [string] (Read-Host "Page Height   ($origPageHeight)")
    $newLeftMargin   = [string] (Read-Host "Left Margin   ($origLeftMargin)")
    $newRightMargin  = [string] (Read-Host "Right Margin  ($origRightMargin)")
    $newTopMargin    = [string] (Read-Host "Top Margin    ($origTopMargin)")
    $newBottomMargin = [string] (Read-Host "Bottom Margin ($origBottomMargin)")

    if ($newPageWidth -eq "") {
        $newPageWidth = $origPageWidth
    }if ($newPageHeight -eq "") {
        $newPageHeight = $origPageHeight
    }if ($newLeftMargin -eq "") {
        $newLeftMargin = $origLeftMargin
    }if ($newRightMargin -eq "") {
        $newRightMargin = $origRightMargin
    }if ($newTopMargin -eq "") {
        $newTopMargin = $origTopMargin
    }if ($newBottomMargin -eq "") {
        $newBottomMargin = $origBottomMargin
    }

    Write-Host -f Green "New Settings: "
    Write-Host -f Green ($curr -f $newPageWidth, $newPageHeight,
    ` $newLeftMargin, $newRightMargin, $newTopMargin, $newBottomMargin)
    
    $confirmation = Read-Host "Do you want to save these settings (y|n)?"
    if ($confirmation -eq 'y') {

        $rdlc.Report.Page.PageWidth = $newPageWidth
        $rdlc.Report.Page.PageHeight = $newPageHeight
        $rdlc.Report.Page.LeftMargin = $newLeftMargin
        $rdlc.Report.Page.RightMargin = $newRightMargin
        $rdlc.Report.Page.TopMargin = $newTopMargin
        $rdlc.Report.Page.BottomMargin = $newBottomMargin

        $ScriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition
        $rdlc.Save("$ScriptPath\$filename")
        Write-Host -f Green "New Settings have been saved to file."
    }else
    {
        Write-Host -f Red "New Settings have not been saved."
    }
}