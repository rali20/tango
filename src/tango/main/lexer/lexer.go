package main

import (
	"fmt"
	"io/ioutil"
	"os"

	"github.com/olekukonko/tablewriter"

	"tango/lexer"
	"tango/token"
)

type countMap map[token.Type]int
type setMap map[token.Type]map[string]bool

func main() {
	counts := make(countMap)
	sets := make(setMap)
	if len(os.Args) < 2 {
		fmt.Printf("Usage: %s <file name>\n", os.Args[0])
		os.Exit(1)
	}
	input, err := ioutil.ReadFile(os.Args[1])
	if err != nil {
		fmt.Printf("Unable to read file: %s\n", os.Args[1])
		return
	}
	l := lexer.NewLexer(input)
	for tok := l.Scan(); tok.Type != token.EOF; tok = l.Scan() {
		switch {
		case tok.Type == token.INVALID:
			fmt.Printf("Invalid token found: %s\n", tok.Lit)
			os.Exit(2)
		default:
			counts[tok.Type]++
			set, ok := sets[tok.Type]
			if !ok {
				set = make(map[string]bool)
			}
			set[string(tok.Lit)] = true
			sets[tok.Type] = set
		}
	}
	data := make([][]string, 0)
	for t, count := range counts {
		tokenID := token.TokMap.Id(t)
		countAsString := fmt.Sprintf("%d", count)
		firstEntry := []string{tokenID, countAsString, ""}
		firstEntryDone := false
		for lit := range sets[t] {
			if !firstEntryDone {
				firstEntry[2] = lit
				firstEntryDone = true
				data = append(data, firstEntry)
				continue
			}
			data = append(data, []string{"", "", lit})
		}
	}
	table := tablewriter.NewWriter(os.Stdout)
	table.SetHeader([]string{"Token", "Occurrences", "Lexemes"})
	table.AppendBulk(data)
	table.Render()
}
