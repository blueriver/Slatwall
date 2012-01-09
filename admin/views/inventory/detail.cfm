<!---

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<cfparam name="rc.entity" type="any">

<cfoutput>
	<div class="svoinventorydetailproduct">
		<dl class="twoColumn">
			<dt>#$.slatwall.rbKey('define.qoh.full')#</dt>
			<dd>#rc.entity.getQOH()#</dd>
			<dt>#$.slatwall.rbKey('define.qosh.full')#</dt>
			<dd>#rc.entity.getQOSH()#</dd>
			<dt>#$.slatwall.rbKey('define.qndoo.full')#</dt>
			<dd>#rc.entity.getQNDOO()#</dd>
			<dt>#$.slatwall.rbKey('define.qndorvo.full')#</dt>
			<dd>#rc.entity.getQNDORVO()#</dd>
			<dt>#$.slatwall.rbKey('define.qndosa.full')#</dt>
			<dd>#rc.entity.getQNDOSA()#</dd>
			<dt>#$.slatwall.rbKey('define.qnroro.full')#</dt>
			<dd>#rc.entity.getQNRORO()#</dd>
			<dt>#$.slatwall.rbKey('define.qnrovo.full')#</dt>
			<dd>#rc.entity.getQNROVO()#</dd>
			<dt>#$.slatwall.rbKey('define.qnrosa.full')#</dt>
			<dd>#rc.entity.getQNROSA()#</dd>
			<dt>#$.slatwall.rbKey('define.qr.full')#</dt>
			<dd>#rc.entity.getQR()#</dd>
			<dt>#$.slatwall.rbKey('define.qs.full')#</dt>
			<dd>#rc.entity.getQS()#</dd>
			<dt>#$.slatwall.rbKey('define.qc.full')#</dt>
			<dd>#rc.entity.getQC()#</dd>
			<dt>#$.slatwall.rbKey('define.qe.full')#</dt>
			<dd>#rc.entity.getQE()#</dd>
			<dt>#$.slatwall.rbKey('define.qnc.full')#</dt>
			<dd>#rc.entity.getQNC()#</dd>
			<dt>#$.slatwall.rbKey('define.qats.full')#</dt>
			<dd>#rc.entity.getQATS()#</dd>
			<dt>#$.slatwall.rbKey('define.qiats.full')#</dt>
			<dd>#rc.entity.getQIATS()#</dd>
		</dl>
	</div>
</cfoutput>