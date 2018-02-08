// +build !debug

package lexer

import (
	"tango/src/tango/token"
)

// Wrapper around the main lexer for inserting semicolons as needed.
type Wrapper struct {
	lexer         *Lexer
	prevTokenType token.Type
}

// NewWrapper returns a new lexer wrapper.
func NewWrapper(src []byte) *Wrapper {
	lexer := &Lexer{
		src:    src,
		pos:    0,
		line:   1,
		column: 1,
	}
	return &Wrapper{
		lexer: lexer,
	}
}

// Scan returns the next token in the stream
func (w *Wrapper) Scan() (tok *token.Token) {
	beforePos := w.lexer.pos
	beforeLine := w.lexer.line
	beforeCol := w.lexer.column
	for tok = w.lexer.Scan(); tok.Type == token.TokMap.Type("comment"); tok = w.lexer.Scan() {
	}
	if w.lexer.line > beforeLine {
		switch w.prevTokenType {
		case token.TokMap.Type("identifier"):
			fallthrough
		case token.TokMap.Type("int_lit"):
			fallthrough
		case token.TokMap.Type("float_lit"):
			fallthrough
		case token.TokMap.Type("rune_lit"):
			fallthrough
		case token.TokMap.Type("string_literal"):
			fallthrough
		case token.TokMap.Type("keyword_break"):
			fallthrough
		case token.TokMap.Type("keyword_continue"):
			fallthrough
		case token.TokMap.Type("keyword_fallthrough"):
			fallthrough
		case token.TokMap.Type("keyword_return"):
			fallthrough
		case token.TokMap.Type("inc_dec_op"):
			fallthrough
		case token.TokMap.Type("right_block_bracket"):
			fallthrough
		case token.TokMap.Type("right_paren"):
			fallthrough
		case token.TokMap.Type("right_sq_paren"):
			tok.Type = token.TokMap.Type("stmt_end")
			tok.Lit = []byte{';'}
			tok.Pos.Line = beforeLine
			tok.Pos.Column = beforeCol

			w.lexer.pos = beforePos
			w.lexer.line = beforeLine
			w.lexer.column = beforeCol
		}
	}
	w.prevTokenType = tok.Type
	return
}
