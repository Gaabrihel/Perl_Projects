use strict;
use warnings;
use POSIX qw(floor);

print "Calculadora em Perl, pressione 'h' para mais informações.\n\n";

# Exibe informações sobre a versão do programa
sub display_version {
    print<<"END";
Versão 1.0.
2024-20xx.
Este é um software livre, sem NENHUMA GARANTIA.\n
END
}

# Exibe ajuda sobre os comandos disponíveis e expressões permitidas
sub display_help {
    print<<"END"
\nComandos disponíveis:
q - Sair do programa
c - Limpar a tela
v - Exibir informações como: versão, licença e garantia
h - Exibir este quadro de ajuda\n 
Expressões permitidas são:
    Simples:
        +, -, *, /
    Complexas:
        sqrt() - raiz quadrada
        log()  - logaritmo natural
        cos()  - cosseno em graus\n
END
}

# Calcula e exibe a raiz quadrada de uma expressão
sub calculate_sqrt {
    my $expr = shift;
    if ($expr < 0) {
        print "Não é possível calcular a raiz quadrada de um número negativo.\n";
    } elsif ($expr == 0) {
        print "A raiz quadrada de zero é zero.\n";
    } else {
        my $result = sqrt($expr);
        print "sqrt($expr) = $result\n";
    }
}

# Calcula e exibe o logaritmo natural de uma expressão
sub calculate_log {
    my $expr = shift;
    if ($expr <= 0) {
        print "O logaritmo não é definido para valores menores ou iguais a zero.\n";
    } else {
        my $result = log($expr);
        print "log($expr) = $result\n";
    }
}

# Calcula e exibe o cosseno em graus de uma expressão
sub calculate_cos {
    my $expr = shift;
    my $radians = $expr * (3.14159265358979 / 180);
    my $result = cos($radians);
    print "cos($expr graus) = $result\n";
}

# Processa a expressão matemática fornecida pelo usuário
sub handle_expression {
    my $input = shift;
    $input =~ s/\s+//g;

    # Verifica e calcula funções matemáticas específicas
    if ($input =~ /^sqrt\(\s*(\d+(\.\d+)?)\s*\)$/i) {
        calculate_sqrt($1);
    } elsif ($input =~ /^log\(\s*(-?\d+(\.\d+)?)\s*\)$/i) {
        calculate_log($1);
    } elsif ($input =~ /^cos\(\s*(\d+(\.\d+)?)\s*\)$/i) {
        calculate_cos($1);
    } else {
        # Avalia e exibe a expressão matemática genérica
        my $result;
        my $error;
        {
            local $SIG{__DIE__} = sub { $error = $_[0] };  # Captura erros fatais
            $result = eval {
                my $eval_result = eval $input;  # Avalia a expressão
                die "Avaliação inválida" if $@;  # Verifica erros na avaliação
                $eval_result;
            };
        }
        # Exibe o resultado se não houver erro
        if (!$error && defined $result) {
            print "$input = $result\n";
        }
    }
}

# Função principal que gerencia os comandos e expressões
sub main {
    print "Digite um comando ou expressão: ";
    my $input = <STDIN>;
    chomp($input);

    if ($input =~ /^q$/i) {
        print "\nSaindo...\n";
        return 0;
    }
    
    if ($input =~ /^c$/i) {
        system('clear');  # Limpa a tela no Linux
        return 1;
    }

    if ($input =~ /^v$/i) {
        display_version();
        return 1;
    }

    if ($input =~ /^h$/i) {
        display_help();
        return 1;
    }

    # Evita a chamada para handle_expression com entrada vazia
    if ($input ne '') {
        handle_expression($input);
    } else {
        print "Entrada vazia. Por favor, digite uma expressão válida.\n";
    }
    
    return 1;
}

# Loop principal do programa
while (main()) {}
