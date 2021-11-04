![HAL-9000](https://github.com/jorres/hal-9000/blob/master/hal9000.png?raw=true)

## HAL-9000

I've always been fascinated by the concept of computer-assisted thinking. 
In a way, programmers enjoy computer assistance all the time - compilers
find their bugs, fuzzy finders search their docs insanely fast, and so on. 

Wouldn't it be cool if we could use our metal friends for a little more? 
For instance, imagine yourself tackling some difficult problem, typing 
your thoughts in an editor. The problem is so difficult every bit of help 
is appreciated! Why not give a text completion model a go? Feed into it 
your current context and let it try generating some insight for you! Even 
if it won't end up answering your question, you might get some clues on 
what way to think further. 
 

This is a **work in progress** integration of computer-assisted thinking into Neovim using HuggingFace Transformers library.

Todo right now:
replace pipe lua communication with http lua communication
test conversation integration within an editor

Todo:

- [UI] make idle animation smoother
- [NLP] support question answering model
- [NLP] support blank filling model 
