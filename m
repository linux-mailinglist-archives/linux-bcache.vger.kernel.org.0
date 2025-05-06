Return-Path: <linux-bcache+bounces-1028-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF46DAABC69
	for <lists+linux-bcache@lfdr.de>; Tue,  6 May 2025 10:03:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 289F4506D6F
	for <lists+linux-bcache@lfdr.de>; Tue,  6 May 2025 08:03:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBD9F17D2;
	Tue,  6 May 2025 07:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=orange.fr header.i=@orange.fr header.b="K1GdjdLO"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.smtpout.orange.fr (smtp-21.smtpout.orange.fr [80.12.242.21])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFF5145348
	for <linux-bcache@vger.kernel.org>; Tue,  6 May 2025 07:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746518165; cv=none; b=JFtUuPVxHG7PbjRC//9Pgo1CfVUo7shvPBZeWCvsiip7j0caKDjIHiHoOOWsk2yyr9Aq4Wq29dgu3gkIaqNnop8cpib1diz91RVGRk43Pa5kqnA0EjmcNsg2K/5Dy1wN5SldE8WDJRk9IESjX/nk+sLxWg6uvJMy4Xxg08N0oY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746518165; c=relaxed/simple;
	bh=Qc+59u1Ew3cIOcSg6MT2xSZxo840BZDR5GlkgWhCYBE=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:References:
	 In-Reply-To:Content-Type; b=puRFURH1pYvxltNIxqCpLiMx2QaXsG4LlX/y9SEU8yGVbh7MXWKZ4NG5pO3bn8OaKqNuGu73o2J3LkTg5b0nSeyia07iVKKA0iZYDCWLKOm+rfkVj0QyM/2HrOpPgFPGHt0WqTzRuzbig0wf7Z5+9QFFKLdDbk6XEitGcrKOYFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=orange.fr; spf=pass smtp.mailfrom=orange.fr; dkim=pass (2048-bit key) header.d=orange.fr header.i=@orange.fr header.b=K1GdjdLO; arc=none smtp.client-ip=80.12.242.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=orange.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=orange.fr
Received: from [192.168.1.7] ([82.124.218.55])
	by smtp.orange.fr with ESMTPA
	id CD0yuWkFuJXr3CD11unh8H; Tue, 06 May 2025 09:46:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orange.fr;
	s=t20230301; t=1746517619;
	bh=ntsOSfv9484W1RIfCxCx2AzeL/ZUWCwg7GH7ztlAHEM=;
	h=Message-ID:Date:MIME-Version:From:Subject:To;
	b=K1GdjdLOwalizBveKTstqMDOF3SS4+6aNEaNrwPAbBh4ZBXtL8KTVAi6/u1JDwWz8
	 xeR13cdaDmJ3ZxpYQVdVRueXNYyJGkuIDkKZo+DaWLoIIANLV9ftwUZep8+UtsqwjV
	 9tl9eP7kiXN/mRdNM8W9IA1OFNnK+PuwfZSMfsRlVEHcGmueb15RlDZdlwpk1Z/MMA
	 LZRpC9yUG2+5p03elA2K7xFYo/u0i0pSKFr3U4AxHSqdxKsG+4fEkvnJzb46cI0IRN
	 3nTKQ+FvQqWgmmO0Bl44YX1tkUlg9PEUJyZ3C96QtcGK1F+lsx11p22OPSGrvxsaVY
	 NaYB0HvL5KNRQ==
X-ME-Helo: [192.168.1.7]
X-ME-Auth: cGllcnJlLmp1aGVuQG9yYW5nZS5mcg==
X-ME-Date: Tue, 06 May 2025 09:46:59 +0200
X-ME-IP: 82.124.218.55
Message-ID: <15e2c02b-8ceb-4091-b487-165b86a4ff13@orange.fr>
Date: Tue, 6 May 2025 09:46:56 +0200
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Pierre Juhen <pierre.juhen@orange.fr>
Subject: bcache device tentative status systemctl
To: linux-bcache@vger.kernel.org
References: <20250418084443.7443-1-zhoujifeng@kylinos.com.cn>
Content-Language: fr, en-GB, en-US
In-Reply-To: <20250418084443.7443-1-zhoujifeng@kylinos.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

doing a systemctl list-units, I get :

dev-bcache-by\x2duuid-dae26eae\x2d42e9\x2d4fac\x2d8370\x2dd5e87bd28a53.device 
loaded activating 
tentative**/dev/bcache/by-uuid/dae26eae-42e9-4fac-8370-d5e87bd28a53

Is it normal ?

Thanks,

Pierre


