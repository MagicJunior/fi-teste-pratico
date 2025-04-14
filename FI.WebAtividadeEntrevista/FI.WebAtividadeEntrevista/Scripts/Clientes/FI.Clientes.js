let beneficiarios = [];
let cpfEmEdicao = null; // CPF do beneficiário que está sendo editado

$(document).ready(function () {
    var url = $('#formCadastro').attr('action') || urlPost;

    $('#CPF').mask('000.000.000-00', { reverse: true });
    $('#cpfBeneficiario').mask('000.000.000-00');

    $(document).on('click', '#btnBeneficiarios', function () {
        $('#modalBeneficiarios').modal('show');
    });

    $('#listaBeneficiarios tr').each(function () {
        var cpf = $(this).find('td:eq(0)').text().trim();
        var nome = $(this).find('td:eq(1)').text().trim();

        if (cpf && nome) {
            beneficiarios.push({ CPF: cpf, Nome: nome });
        }
    });

    // Incluir ou Salvar edição de beneficiário
    $('#btnIncluirBeneficiario').click(function () {
        const cpf = $('#cpfBeneficiario').val();
        const nome = $('#nomeBeneficiario').val();

        if (!cpf || !nome) {
            ModalDialog("Atenção", "Preencha CPF e Nome do beneficiário.");
            return;
        }

        if (!validarCPF(cpf)) {
            ModalDialog("CPF inválido", "Informe um CPF válido para o beneficiário.");
            return;
        }

        // MODO EDIÇÃO
        if (cpfEmEdicao) {
            // Atualiza no array
            beneficiarios = beneficiarios.map(b => {
                if (b.CPF === cpfEmEdicao) return { CPF: cpf, Nome: nome };
                return b;
            });

            // Atualiza na tabela
            const linha = $(`#listaBeneficiarios tr[data-cpf='${cpfEmEdicao}']`);
            linha.find('td:eq(0)').text(cpf);
            linha.find('td:eq(1)').text(nome);
            linha.attr('data-cpf', cpf); // Atualiza o atributo também

            cpfEmEdicao = null;
            $('#btnIncluirBeneficiario').text('Incluir');
        }
        // MODO INCLUSÃO
        else {
            let cpfDuplicado = beneficiarios.some(b => b.CPF === cpf);
            if (cpfDuplicado) {
                ModalDialog("Duplicidade", "Este CPF já foi incluído para este cliente.");
                return;
            }

            beneficiarios.push({ CPF: cpf, Nome: nome });

            const linha = `
                <tr data-cpf="${cpf}">
                    <td>${cpf}</td>
                    <td>${nome}</td>
                    <td>
                        <button type="button" class="btn btn-sm btn-primary" onclick="editarBeneficiario('${cpf}')">Alterar</button>
                        <button type="button" class="btn btn-sm btn-primary" onclick="removerBeneficiario(this)">Excluir</button>
                    </td>
                </tr>
            `;
            $('#listaBeneficiarios').append(linha);
        }

        $('#cpfBeneficiario').val('');
        $('#nomeBeneficiario').val('');
    });

    // Submissão do formulário
    $('#formCadastro').submit(function (e) {
        e.preventDefault();

        var cpf = $(this).find("#CPF").val();
        if (!validarCPF(cpf)) {
            ModalDialog("CPF inválido", "Por favor, informe um CPF válido.");
            return;
        }

        // Atualiza lista a partir da tabela (garantia extra)
        beneficiarios = [];
        $('#listaBeneficiarios tr').each(function () {
            var cpf = $(this).find('td:eq(0)').text().trim();
            var nome = $(this).find('td:eq(1)').text().trim();
            if (cpf && nome) {
                beneficiarios.push({ CPF: cpf, Nome: nome });
            }
        });

        var formData = $(this).serializeArray();

        if (beneficiarios.length > 0) {
            formData.push({ name: "Beneficiarios", value: JSON.stringify(beneficiarios) });
        }

        $.ajax({
            url: url,
            method: "POST",
            data: formData,
            error: function (r) {
                if (r.status == 400)
                    ModalDialog("Ocorreu um erro", r.responseJSON);
                else if (r.status == 500)
                    ModalDialog("Ocorreu um erro", "Ocorreu um erro interno no servidor.");
            },
            success: function (r) {
                ModalDialog("Sucesso!", r);
                $("#formCadastro")[0].reset();
                $('#listaBeneficiarios').empty();
                beneficiarios = [];
            }
        });
    });
});

// Função para iniciar a edição de um beneficiário
function editarBeneficiario(cpf) {
    const beneficiario = beneficiarios.find(b => b.CPF === cpf);
    if (!beneficiario) return;

    $('#cpfBeneficiario').val(beneficiario.CPF);
    $('#nomeBeneficiario').val(beneficiario.Nome);

    cpfEmEdicao = cpf;
    $('#btnIncluirBeneficiario').text('Salvar');
}

// Remoção
function removerBeneficiario(button) {
    const linha = $(button).closest('tr');
    const cpf = linha.find('td:first').text();

    linha.remove();
    beneficiarios = beneficiarios.filter(b => b.CPF !== cpf);

    // Se estiver editando esse mesmo, reseta
    if (cpfEmEdicao === cpf) {
        $('#cpfBeneficiario').val('');
        $('#nomeBeneficiario').val('');
        cpfEmEdicao = null;
        $('#btnIncluirBeneficiario').text('Incluir');
    }
}

// CPF Validator
function validarCPF(cpf) {
    cpf = cpf.replace(/[^\d]+/g, '');
    if (cpf.length !== 11 || /^(\d)\1{10}$/.test(cpf)) return false;

    let soma = 0;
    for (let i = 0; i < 9; i++) soma += parseInt(cpf.charAt(i)) * (10 - i);
    let resto = 11 - (soma % 11);
    let digito1 = resto >= 10 ? 0 : resto;

    soma = 0;
    for (let i = 0; i < 10; i++) soma += parseInt(cpf.charAt(i)) * (11 - i);
    resto = 11 - (soma % 11);
    let digito2 = resto >= 10 ? 0 : resto;

    return digito1 === parseInt(cpf.charAt(9)) && digito2 === parseInt(cpf.charAt(10));
}

// Modal
function ModalDialog(titulo, texto) {
    var random = Math.random().toString().replace('.', '');
    var html = '<div id="' + random + '" class="modal fade">' +
        '        <div class="modal-dialog">' +
        '            <div class="modal-content">' +
        '                <div class="modal-header">' +
        '                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>' +
        '                    <h4 class="modal-title">' + titulo + '</h4>' +
        '                </div>' +
        '                <div class="modal-body">' +
        '                    <p>' + texto + '</p>' +
        '                </div>' +
        '                <div class="modal-footer">' +
        '                    <button type="button" class="btn btn-default" data-dismiss="modal">Fechar</button>' +
        '                </div>' +
        '            </div>' +
        '        </div>' +
        '</div>';

    $('body').append(html);
    $('#' + random).modal('show');
}
