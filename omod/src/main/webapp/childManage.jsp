<%@ include file="/WEB-INF/template/include.jsp"%>

<openmrs:require privilege="Manage PTME" otherwise="/login.htm" redirect="/module/ptme/childManage.form" />
<%@ include file="/WEB-INF/template/header.jsp"%>

<%@ include file="template/localHeader.jsp"%>

<script type="application/javascript">
    if (jQuery) {
        $(document).ready(function () {
            $("#list-child-to-follow").dataTable({
                "pageLength": 20,
                "order": [[1, "asc"]],
                "language": {
                    "zeroRecords": "Aucun enregistrement trouv&eacute;",
                    //"emptyTable": "Aucune donn&eacute;e",
                    paginate: {
                        previous: 'Pr&eacute;c&eacute;dent',
                        next:     'Suivant'
                    },
                    "info":"Affichage de _START_ a _END_ sur _TOTAL_ ",
                    "search": "Filtrer les enfants expos&eacute;"
                },
                "lengthChange": false,
                "stripeClasses": [ 'odd', 'even' ]
            });
        });
    }
</script>

<%@ include file="template/chlidFollowupHeader.jsp"%>

<c:if test="${mode == 'list' || empty mode}">
    <div class="box">
        <h3><b>Saisie des enfants expos&eacute;s</b></h3>

        <div class="line"></div>
        <form:form action="" modelAttribute="findPregnantPatientForm" id="form" method="get" >
            <table cellspacing="0" cellpadding="5">
                <tr>

                        <%--<td>Num&eacute;ro identifiant de la m&egrave;re : </td>
                        <td><form:input path="hivCareNumber" cssClass=""/></td>--%>
                    <td><input type="submit" value="Ajouter un enfant" name="add"></td>
                </tr>
            </table>
        </form:form>
    </div>
    <div class="boxHeader"></div>
    <div class="box">
        <h3>Liste des enfants expos&eacute;s</h3>
        <div class="line"></div>
        <table width="100%" style="border: solid #1aac9b 1px" cellpadding="5" cellspacing="0" id="list-child-to-follow">
            <thead>
            <tr style="background-color: #1aac9b; color: #ffffff;">
                <th>Num&eacute;ro Identifiant de l'enfant</th>
                <th>Nom et Pr&eacute;nom</th>
                <th>Date de naissance</th>
                <th>Genre</th>
                <th>Num&eacute;ro de la m&egrave;re</th>
                <th>Nom et pr&eacute;nom de la m&egrave;re</th>
                <th>Age de la m&egrave;re</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="child" items="${ childList }">
                <tr <c:if test="${empty child.childFollowupVisits}"> style="font-style: italic; color: #F44336; font-weight: bold;" </c:if>>
                    <td>
                        <c:url value="/module/ptme/childFollowup.form" var="fUrl">
                            <c:param name="childFollowupNumber" value="${child.childFollowupNumber}"/>
                        </c:url>
                        <a href="${fUrl}">${child.childFollowupNumber}</a>
                    </td>
                    <td>${child.familyName} ${child.givenName}</td>
                    <td><fmt:formatDate type="date" value="${child.birthDate}" pattern="dd/MM/yyyy" /></td>
                    <td>${child.gender}</td>
                    <td>${child.mother.patientIdentifier.identifier}</td>
                    <td>${child.mother.familyName}
                            ${child.mother.givenName}</td>
                    <td>${child.mother.age} ${ not empty child.mother.age ? 'ans' : '' }</td>
                    <td>
                        <table cellpadding="0" cellspacing="0" class="button-table">
                            <tr>
                                <td>
                                    <c:url value="/module/ptme/childManage.form" var="url">
                                        <c:param name="childId" value="${child.childId}"/>
                                    </c:url>
                                    <a href="${ url }"><img src="/openmrs/images/edit.gif" alt="Editer"></a>
                                </td>
                                <td>|</td>
                                <td>
                                    <c:url value="/module/ptme/childManage.form" var="urlsup">
                                        <c:param name="delId" value="${child.childId}"/>
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
        <h3><b>Saisie des enfants expos&eacute;s</b></h3>
        <div class="line"></div>
        <form:form action="" modelAttribute="childForm" id="form" method="post" >
            <form:hidden path="childId"/>
            <form:hidden path="motherPatientId"/>
            <form:hidden path="motherAge"/>
            <form:hidden path="motherName"/>
            <%--<form:hidden path="motherHivCareNumber"/>--%>
            <form:hidden path="patientId"/>
            <table cellpadding="5" cellspacing="0">
                    <%--<tr>
                            <td class="boldText" colspan="3">
                                <fieldset>
                                    <legend>Information sur la m&egrave;re</legend>
                                    <table cellpadding="5" cellspacing="0">
                                        <tr>
                                            <td class="boldText">Num&eacute;ro identifiant : </td>
                                            <td class="colored-blue">${childForm.motherHivCareNumber}</td>
                                        </tr>
                                        <tr>
                                            <td class="boldText">Nom et pr&eacute;noms :</td>
                                            <td class="colored-blue">${childForm.motherName }</td>
                                        </tr>
                                        <tr>
                                            <td class="boldText">Age de la m&egrave;re</td>
                                            <td class="colored-blue">${childForm.motherAge} ans</td>
                                        </tr>
                                    </table>
                                </fieldset>

                            </td>
                    </tr>--%>
                <tr>
                    <td class="boldText">Num&eacute;ro identifiant de l'enfant <b class="required">*</b> : </td>
                    <td><form:input path="childFollowupNumber" cssClass=""/></td>
                    <td><form:errors cssClass="error" path="childFollowupNumber"/></td>
                </tr>
                <tr>
                    <td class="boldText">Nom <b class="required">*</b> : </td>
                    <td><form:input path="familyName" cssClass=""/></td>
                    <td><form:errors cssClass="error" path="familyName"/></td>
                </tr>
                <tr>
                    <td class="boldText">Pr&eacute;nom <b class="required">*</b> : </td>
                    <td><form:input path="givenName" cssClass=""/></td>
                    <td><form:errors cssClass="error" path="givenName"/></td>
                </tr>
                <tr>
                    <td class="boldText">Date de naissance <b class="required">*</b> : </td>
                    <td><form:input path="birthDate"  cssClass="datepickerPtme"/></td>
                    <td><form:errors cssClass="error" path="birthDate"/></td>
                </tr>
                <tr>
                    <td class="boldText">Sexe <b class="required">*</b> : </td>
                    <td>
                        <form:radiobutton path="gender" value="M" label="M" cssClass=""/>
                        <form:radiobutton path="gender" value="F" label="F" cssClass=""/>
                    </td>
                    <td><form:errors cssClass="error" path="gender"/></td>
                </tr>
                <tr>
                    <td class="boldText">Num&eacute;ro de la m&eacute;re : </td>
                    <td><form:input path="motherHivCareNumber" cssClass=""/></td>
                    <td><form:errors cssClass="error" path="motherHivCareNumber"/></td>
                </tr>
            </table>
            <div class="line"></div>
            <table cellspacing="0" cellpadding="5">
                <tr>
                    <td>
                        <c:if test="${ empty childForm.childId }">
                            <input type="submit" value="Enregistrer" name="action"/>
                        </c:if>
                        <c:if test="${ not empty childForm.childId  }">
                            <input type="submit" value="Modifier" name="action"/>
                        </c:if>
                    </td>
                </tr>
            </table>
        </form:form>
    </div>
</c:if>
<%@ include file="template/localFooter.jsp"%>