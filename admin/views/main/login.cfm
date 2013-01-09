<div style="width:100%;">
	<div class="well" style="width:400px;margin: 0px auto;">
		<h3>Login</h3>
		<br />
		<form action="?s=1" class="form-horizontal">
			<input type="hidden" name="slatAction" value="admin:main.login" />
			<fieldset class="dl-horizontal">
				<div class="control-group">
					<label class="control-label" for="email">Email</label>
					<div class="controls">
						<input type="text" name="email" placeholder="Email">
					</div>
				</div>
				<div class="control-group">
					<label class="control-label" for="password">Password</label>
					<div class="controls">
						<input type="password" name="password" placeholder="Password">
					</div>
				</div>
				<button type="submit" class="btn btn-primary pull-right">Login</button>
			</fieldset>
		</form>
		<hr />
		<h3>Login with Mura Account</h3>
		<br />
		<form action="?s=1" class="form-horizontal">
			<input type="hidden" name="slatAction" value="mura:account.login" />
			<fieldset class="dl-horizontal">
				<div class="control-group">
					<label class="control-label" for="username">Username</label>
					<div class="controls">
						<input type="text" name="username" placeholder="Username">
					</div>
				</div>
				<div class="control-group">
					<label class="control-label" for="password">Password</label>
					<div class="controls">
						<input type="password" name="password" placeholder="Password">
					</div>
				</div>
				<button type="submit" class="btn pull-right">Login w/Mura</button>
			</fieldset>
		</form>
	</div>
</div>