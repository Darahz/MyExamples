Function Convert-ImageToBinary($infile,$outfile){

    $Bytes = [System.IO.File]::ReadAllBytes($infile)
    $sb = [System.Text.StringBuilder]::new()

    foreach($byte in $Bytes){
        $sb.Append([System.Convert]::ToString($byte,2).padLeft(8,'0')) | Out-Null
    }
    $string = $sb.ToString() -split ""

    $SafetyHeigh = 2;
    $ImageHeight = [System.Math]::Round($sb.ToString().length / 1008,0) + $SafetyHeigh;

    $img    = [System.Drawing.Bitmap]::new(1008,$ImageHeight)
    $bitmap = [System.Drawing.Graphics]::FromImage($img)
    $x = 0;
    $y = 0;

    foreach($str in ($string | select -Skip 1)){

        if($x -eq $img.Width){$x = 0;$y += 1;}
        if($y -eq $img.Height){Write-Host "Too big"break;}

        $col = try{[int16]::Parse($str)}catch{Write-Host "Shit";break;}
        if($col -eq 1){$col = 255}
        if($col -eq 0){$col = 0}
        $bitmap.FillRectangle([System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb($col,$col,$col)),$x,$y,1,1)
    
        $x++;
        #Write-Host "x:$($x)\y:$($y)`t$($col) `t $($img.height)"
    }

    $img.Save($outfile, [System.Drawing.Imaging.ImageFormat]::Png)
    #c:\temp\lol.png
}