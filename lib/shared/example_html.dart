const htmlExample = '''
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Exemplo HTML</title>
</head>
<body>
    <h1>Bem-vindo ao Flutter Widget</h1>
    <p>Este é um exemplo de HTML para testar o widget <strong>flutter_widget_from_html</strong>.</p>

    <h2>Imagem</h2>
    <img src="https://media.licdn.com/dms/image/D4D0BAQEtvYp9kjkvdA/company-logo_100_100/0/1721917266773?e=1730937600&v=beta&t=OqKu50OzIC4IR65P8-MT_Z5SZOLQu-xaqjt5xT8WnUg" alt="Imagem de exemplo" style="display:block; border-radius:50%; margin-left:auto; margin-right:auto;">

    <h2>Lista Ordenada</h2>
    <ol>
        <li>Primeiro item</li>
        <li>Segundo item</li>
        <li>Terceiro item</li>
    </ol>

    <h2>Lista Não Ordenada</h2>
    <ul>
        <li>Item A</li>
        <li>Item B</li>
        <li>Item C</li>
    </ul>

    <h2>Tabela</h2>
    <table border="1">
        <tr>
            <th>Nome</th>
            <th>Idade</th>
        </tr>
        <tr>
            <td>João</td>
            <td>30</td>
        </tr>
        <tr>
            <td>Maria</td>
            <td>25</td>
        </tr>
    </table>

    <h2>Iframe</h2>
    <iframe width="560" height="315" src="https://www.youtube.com/embed/-SUOlFVZnZs?si=uI6essbVXQhhL0CN" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

    <h2>Bloco de Código</h2>
    <pre>
        <code>
            void main() {
                print('Hello, Flutter!');
            }
        </code>
    </pre>

    <h2>Link</h2>
    <p>Visite o <a href="https://flutter.dev" target="_blank">site do Flutter</a> para mais informações.</p>
</body>
</html>
''';
