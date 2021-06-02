Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B99398E3D
	for <lists+linux-bcache@lfdr.de>; Wed,  2 Jun 2021 17:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbhFBPUM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 2 Jun 2021 11:20:12 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:56640 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbhFBPUL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 2 Jun 2021 11:20:11 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 99E651FDBB;
        Wed,  2 Jun 2021 15:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622647107; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ng/gmR6PVEQmfcxMiy/v6TrsADgj8LvexWWi3hMoFug=;
        b=meFhSfUE9vXt7UicqP4l3WCa0yGONHYn2KRtqfj6AJ9Hiwu0BjX9lg6jsc3TIw4N6H71G2
        XTa36etecNZIXCdDR8EkHi0UvvTPAeGZyO3wbfnhZ+VN/y+5TfIkjq2gd2q4sN895puz0/
        pplF8TbTTtjobZSwQIgC6Mp7sF2XsuI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622647107;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ng/gmR6PVEQmfcxMiy/v6TrsADgj8LvexWWi3hMoFug=;
        b=JuHShlqWMv+mzdv2ruEQUq0+ir758QWZC60gWpcNx+pRgZvnMFzEORfHJ/6zBT5NTRDKoy
        ekSxCJT9W/yH2xCw==
Received: by imap.suse.de (Postfix, from userid 51)
        id 95C6611CF5; Wed,  2 Jun 2021 15:28:32 +0000 (UTC)
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 48F8E11DC2;
        Wed,  2 Jun 2021 11:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622632117; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ng/gmR6PVEQmfcxMiy/v6TrsADgj8LvexWWi3hMoFug=;
        b=a3ySXm7nvnrO4XHN+dGWPYfGgtwmDwIBaTYeJbGgU2ERsevkHUaBGEQwsZqRtad5Pdv7eI
        2RvbnNwB1NqDDSX2lQBTOGDn2KlfWTiSduquCaSEstbe32kbE6aw6jXTgFE+tjKuBCqN9D
        NJxjJ0r8wGn1W1zOv67fuuRGXboITtw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622632117;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ng/gmR6PVEQmfcxMiy/v6TrsADgj8LvexWWi3hMoFug=;
        b=2YQ5A9sb3ebe75Ssh3YW9r5v54avPBgoGp7NzNWmpKk0Nq5Gnb5wwPyVradhy4q0YLhJ84
        kQS9i0HV/b0ATEBg==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id bnTwBbRmt2DOZgAALh3uQQ
        (envelope-from <colyli@suse.de>); Wed, 02 Jun 2021 11:08:36 +0000
Subject: Re: PROBLEM: bcache related kernel BUG() since Linux 5.12
To:     Rolf Fokkens <rolf@rolffokkens.nl>,
        Thorsten Knabe <linux@thorsten-knabe.de>
Cc:     linux-bcache@vger.kernel.org
References: <58f92cd7-38d1-bc16-2b5f-b68b2db2233b@thorsten-knabe.de>
 <f2f917d5-330b-a5cc-cca1-fe79a32c2140@rolffokkens.nl>
 <7e3c8a62-71d4-11a7-5dd7-137c030f5aad@suse.de>
 <92f2fb24-0d19-939d-a37a-91b9c1da4ac1@thorsten-knabe.de>
 <2a37723c-bc91-351d-5b0e-e7d104f88141@rolffokkens.nl>
From:   Coly Li <colyli@suse.de>
Message-ID: <69319c4e-71fe-5c7d-955f-801fdb9d9cba@suse.de>
Date:   Wed, 2 Jun 2021 19:08:34 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <2a37723c-bc91-351d-5b0e-e7d104f88141@rolffokkens.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/2/21 5:45 PM, Rolf Fokkens wrote:
> Hi Coli,
>
> Things are stable so far, looks really promising:
>
> bash-5.0$ cat /proc/version
> Linux version 5.12.8-200.rf.fc33.x86_64
> (mockbuild@tb-sandbox-mjolnir.local.tbai.nl) (gcc (GCC) 10.3.1 20210422
> (Red Hat 10.3.1-1), GNU ld version 2.35-18.fc33) #1 SMP Tue Jun 1
> 23:10:39 CEST 2021
> bash-5.0$ uptime
>  11:42:05 up 12:01,  1 user,  load average: 0.84, 2.43, 3.20
> bash-5.0$
>
> I left the system running during the night, and have been using it
> actively for 3 hours now.


Hi Rolf and Thorsten,

Thank you all for the status update!

>
> I'll keep you posted if anything changes, but this is a major step
> forward for sure (before your patches the system would freeze in minutes
> after booting).


Hope we have the luck in next 48 hours.

Coly Li
