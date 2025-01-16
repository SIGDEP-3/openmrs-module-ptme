<%@ include file="/WEB-INF/template/include.jsp"%>
<openmrs:require privilege="Manage PTME Reports" otherwise="/login.htm" redirect="/module/ptme/reportIndicator.form" />
<%@ include file="/WEB-INF/template/header.jsp"%>

<%@ include file="template/localHeader.jsp"%>

<%@ include file="template/reportHeader.jsp"%>
<style>

    .textarea-c {
        width:100%;
        /*border:none;*/
        text-align: justify;
    }
    .script-textarea-c {
        min-width:800px;
        min-height: 250px;
        font-size: 14px;
        font-family: "Consolas", Helvetica, sans-serif;
    }
    textarea {
        width: 100%;
    }

</style>

<script type="application/javascript">
    if (jQuery) {
        $(document).ready(function () {
            $("#list-indicator").dataTable({
                dom: 'B<"clear">lfrtip',
                buttons: {
                    name: 'primary',
                    buttons: [ 'copy', 'excel' ]
                },
                "pageLength": 20,
                "order": [[1, "asc"]],
                "language": {
                    "zeroRecords": "Aucun indicateur &agrave; afficher",
                    "emptyTable": "Aucune donn&eacute;e",
                    paginate: {
                        previous: 'Pr&eacute;c&eacute;dent',
                        next:     'Suivant'
                    },
                    "info":"Affichage de _START_ a _END_ sur _TOTAL_ ",
                    "search": "Filtrer les indicateurs"
                },
                "lengthChange": false,
                "stripeClasses": [ 'odd', 'even' ]

            });

        });
    }
</script>
<c:if test="${mode == 'list' || empty(mode)}">
    <div class="box">
        <h3><b>Gestion des indicateurs</b></h3>

        <div class="line"></div>
        <form:form action="" modelAttribute="getIndicatorFromFrom" id="form" method="get" >
            <table cellspacing="0" cellpadding="5">
                <tr>
                    <td><input type="submit" value="Nouveau" name="add"></td>
                </tr>
            </table>
        </form:form>
    </div>
    <div class="boxHeader"></div>
    <div class="box">
        <h3>Liste des indicateurs</h3>
        <div class="line"></div>
        <table width="100%" style="border: solid #1aac9b 1px" cellpadding="0" cellspacing="0" id="list-indicator">
            <thead>
            <tr style="background-color: #1aac9b; color: #ffffff;">
                <th>code</th>
                <th>Nom</th>
                <th>Description</th>
                <th>Cr&eacute;&eacute; par</th>
                <th>Cr&eacute;&eacute; le</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="indicator" items="${ indicators }">
                <tr>
                    <td>${indicator.templateCode}</td>
                    <td>${indicator.name}</td>
                    <td>${indicator.description}</td>
                    <td>
                        <c:forEach var="name" items="${ indicator.creator.person.names }">
                            <c:if test="${ name.preferred }">
                            ${name.familyName} ${name.givenName}
                            </c:if>
                        </c:forEach>
                    </td>
                    <td><fmt:formatDate type="date" value="${indicator.dateCreated}" pattern="dd/MM/yyyy HH:mm:ss" /></td>
                    <td width="30">
                        <table cellpadding="0" cellspacing="0" class="button-table">
                            <tr>
                                <td>
                                    <c:url value="/module/ptme/reportIndicator.form" var="url">
                                        <c:param name="indicatorId" value="${indicator.indicatorId}"/>
                                    </c:url>
                                    <a href="${ url }"><img src="/openmrs/images/edit.gif" alt="Editer"></a>
                                </td>
                                <td>|</td>
                                <td>
                                    <c:url value="/module/ptme/reportIndicator.form" var="urlsup">
                                        <c:param name="delId" value="${indicator.indicatorId}"/>
                                    </c:url>
                                    <a href="${ urlsup }" onclick="return confirm('Voulez-vous vraiment supprimer la ligne ?');">
                                        <img src="/openmrs/images/trash.gif" alt="Supprimer">
                                    </a>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

</c:if>

<c:if test="${mode == 'form'}">
    <div class="box">
        <h3><b>Saisie des indicateurs</b></h3>
        <div class="line"></div>
        <form:form action="" modelAttribute="indicatorForm" id="form" method="post" >
            <form:hidden path="indicatorId"/>
            <table cellspacing="0" cellpadding="5" align="" width="70%">
                <tr>
                    <td>
                        <table cellpadding="5" cellspacing="0" width="100%">
                            <tr>
                                <td class="boldText">Code <b class="required">*</b> : </td>
                                <td><form:input path="templateCode"  size="10" cssClass=""/></td>
                                <td><form:errors cssClass="error" path="templateCode"/></td>
                            </tr>
                            <tr>
                                <td class="boldText">Nom <b class="required">*</b> : </td>
                                <td><form:input path="name" size="80" cssClass=""/></td>
                                <td><form:errors cssClass="error" path="name"/></td>

                            </tr>
                            <tr>
                                <td class="boldText">Description  : </td>
                                <td><form:textarea path="description" rows="5" cssClass="textarea-c" /></td>
                                <td><form:errors cssClass="error" path="description"/></td>
                            </tr>
                            <tr>
                                <td class="boldText">Script SQL <b class="required">*</b> :</td>
                                <td><form:errors cssClass="error" path="indicatorSqlScript"/></td>
                            </tr>
                            <tr>
                                <td colspan="2"><form:textarea path="indicatorSqlScript" cssClass="script-textarea-c" /></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <div class="line"></div>
            <table cellspacing="0" cellpadding="5">
                <tr>
                    <td>
                        <c:if test="${ empty indicatorForm.indicatorId }">
                            <input type="submit" value="Enregistrer" name="action"/>
                        </c:if>
                        <c:if test="${ not empty indicatorForm.indicatorId }">
                            <input type="submit" value="Modifier" name="action"/>
                        </c:if>
                    </td>
                </tr>
            </table>
    </form:form>
    </div>
</c:if>


<%@ include file="template/localFooter.jsp"%>