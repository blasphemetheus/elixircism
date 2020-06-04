defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"

    iex> Markdown.parse("#__Header")
    "<h1>__Header</h1"

    Edits: applied piping format to syntax, broke up nested-if in process/1 with a cond,
    changed variable names to be clearer, changed name of process/1 to apply_tags/1,
    changed variouse names to be more descriptive, modified the regex usage to be clearer,
    reorganized for the sake of passing strings in functions rather than lists of strings

    Observation: It seems that any content in a header tag you should not be adding
    italics and bold tags to (ie <strong> or <em>)


  """
  @spec parse(String.t()) :: String.t()
  def parse(markdown) do
    # splits into a list of strings (each line)
    String.split(markdown, "\n")
    |> Enum.map(&apply_tags_to_line/1)
    |> Enum.join()
    |> insert_unordered_list_tags()
  end

  # if the line starts with #, deal with header
  # if line starts with *, deal with list
  # otherwise split and put in paragraph tags
  defp apply_tags_to_line(line) do
    cond do
      String.starts_with?(line, "#") -> tag_header_line(line) 
      String.starts_with?(line, "*") -> tag_list_line(line)
      true -> tag_paragraph_line(line)
    end
  end

  defp count_hashtags(["#" | rest], count), do: count_hashtags(rest, count + 1)
  defp count_hashtags([_anything_else | _ ], count), do: count

  # EDITS: changed the split operation to only split on the first space
  #  so the rest of the header is left alone, changed variable namess
  defp tag_header_line(raw_header) do
    how_many_hashtags = String.graphemes(raw_header) |> count_hashtags(0)
    {_ , header_content} = String.split_at(raw_header, how_many_hashtags)
    possible_leading_space_eliminated_content = String.replace_prefix(header_content, " ", "")

    how_many_hashtags
    |> to_string()
    |> enclose_with_header_tag(possible_leading_space_eliminated_content)
  end

  defp tag_list_line(raw_list_item) do
    {_, line_content} = String.split_at(raw_list_item, 1)
    possible_leading_space_eliminated_content = String.replace_prefix(line_content, " ", "")

    possible_leading_space_eliminated_content
    |> replace_md_with_tag()
    |> enclose_with_list_item_tag()
  end

  defp tag_paragraph_line(line) do
    line
    |> apply_italic_and_bold_tags()
    |> enclose_with_paragraph_tag()
  end

  #EDIT: put in string interpolation syntax, eliminated tuple as parameter
  defp enclose_with_header_tag(header_size, header_content) do
    "<h#{header_size}>#{header_content}</h#{header_size}>"
  end

  defp enclose_with_list_item_tag(content) do
    "<li>#{content}</li>"
  end

  defp enclose_with_paragraph_tag(content) do
    "<p>#{content}</p>"
  end

  defp apply_italic_and_bold_tags(line) do
    line
    |> replace_md_with_tag()
    |> replace_md_with_tag()
  end

  defp replace_md_with_tag(markdown) do
    markdown
    |> replace_prefix_md()
    |> replace_suffix_md()
  end

  defp replace_prefix_md(line) do
    cond do
      line =~ ~r/__/ -> String.replace(line, ~r/__/, "<strong>", global: false)
      line =~ ~r/_/ -> String.replace(line, ~r/_/, "<em>", global: false)
      true -> line
    end
  end

  defp replace_suffix_md(w) do
    cond do
      w =~ ~r/__/ -> String.replace(w, ~r/__/, "</strong>")
      w =~ ~r/_/ -> String.replace(w, ~r/_/, "</em>")
      true -> w
    end
  end 

  defp insert_unordered_list_tags(string) do
    String.replace(string, "<li>", "<ul><li>")
    |> String.replace_suffix("</li>", "</li></ul>")
    |> String.replace("</ul><li>", "<li>")
    |> String.replace("</li><ul><li>", "</li><li>")
  end
end
