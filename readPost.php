<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>StackOverflow Post</title>
  <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;charset=utf-8"/>
  <link rel="apple-touch-icon" href="icon.png" />
        <script>
        </script>
</head>
<body>
<?php
/* Get the post ID from the URL */
$postId = $_GET["postId"];
/* Run a shell script to read the post from the StackOverflow data dump */
$script = "bash /Users/peter/Sites/StackOverflow/readPost.sh ";
$script .= $postId;

$out = "";
exec ($script, &$out);

$value=$out[0];

/* Expand the compressed version of the row */
$value=str_replace('<<','<row Id="',$value);
$value=str_replace('<>','" AcceptedAnswerId="',$value);
$value=str_replace('><','" Body="',$value);
$value=str_replace('>>','">',$value);

/* Read the accepted answer, to form a link */
$txt=explode('AcceptedAnswerId="',$value);
$txt2=explode('"',$txt[1]);
$answerId=trim($txt2[0]);

/* Replace some control characters to make the output more readable */
$value=str_replace('<','',$value);
$value=str_replace('>','',$value);
$value=str_replace('" ',';',$value);
$value=str_replace('="',': ',$value);
$value=str_replace('&lt;','<',$value);
$value=str_replace('&gt;','>',$value);
$value=str_replace('<code>','<br></br><code>',$value);
$value=str_replace('</code>','</code><br></br>',$value);

/* Display the row to the user */
echo $value;

/* If the answer is not blank (StackOverflow data dump) or 0 (compressed version) */
if($answerId != '')
{
	if($answerId != 0)
	{
		/* Display a link to the answer */
		echo '<br></br><a href="http://localhost/StackOverflow/readPost.php?postId='.$answerId.'">Answer</a>';
	}
}

 ?>
</body>
</html>