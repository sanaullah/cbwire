<cfoutput>
    <div>
        <h1>Super Heroes</h1>

        <p>Number Of Heroes: #heroes.len()#</p>

        <cfif heroes.len()>
            <ul>
                <cfloop array="#heroes#" index="hero">
                    <li>#hero#</li>
                </cfloop>
            </ul>
        </cfif>
    </div>
</cfoutput>