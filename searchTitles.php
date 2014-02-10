<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>StackOverflow Search</title>
  <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;charset=utf-8"/>
  <link rel="apple-touch-icon" href="icon.png" />
        <script>
        </script>
</head>
<body>
<?php
/* Read the search string from the URL */
$searchString = $_GET["searchString"];
/* Run a shell script to search for them */
$script = "bash /Users/peter/Sites/StackOverflow/searchTitles.sh ";
$script .= $searchString;
$out = "";
exec ($script, &$out);

/* Display each line of the output (not just the first line) */
foreach($out as $key=>$value) {
	/* Substitute the delimiter with an additional double-quote to form a URL */
	$value=str_replace('>','">',$value);
	/* Display the search result, with a link to look up the post */
    echo '<br><a href="http://localhost/StackOverflow/readPost.php?postId='.$value.'</a></br>';
}
 ?>
</body>
</html>