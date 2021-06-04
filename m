Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6FC439B732
	for <lists+linux-bcache@lfdr.de>; Fri,  4 Jun 2021 12:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbhFDKhN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 4 Jun 2021 06:37:13 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:54852 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbhFDKhN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 4 Jun 2021 06:37:13 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 337D721A05;
        Fri,  4 Jun 2021 10:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622802926; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DvpECzMFaM5oWy3riv7rVLKUeJn6GGTVhrgcSjdUeoQ=;
        b=0ZGuG/ABf9ziHqaMwqdh9fOT0waHIxJJKF+gfQSLpcWKfrABWheHYgxJNSR8rvSeRGu5Zi
        /WXntJlBxZJCXiDUj55/l5GK3b83aRWgn0QwV0TiQIRHSw8wy30TuP4CaTKeid/79vgGqo
        RDBB8T8V+bv003boHhXE9WKNVGw+j0Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622802926;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DvpECzMFaM5oWy3riv7rVLKUeJn6GGTVhrgcSjdUeoQ=;
        b=+b/ff5jFMgcEtpj1CyCBGyzXj5PQ8c9WpgVbYMWyEbsK6Kjimv7c51zki1Ca05DoxUL4FU
        HNmTVAXbGR03zdAw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 5D991118DD;
        Fri,  4 Jun 2021 10:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622802926; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DvpECzMFaM5oWy3riv7rVLKUeJn6GGTVhrgcSjdUeoQ=;
        b=0ZGuG/ABf9ziHqaMwqdh9fOT0waHIxJJKF+gfQSLpcWKfrABWheHYgxJNSR8rvSeRGu5Zi
        /WXntJlBxZJCXiDUj55/l5GK3b83aRWgn0QwV0TiQIRHSw8wy30TuP4CaTKeid/79vgGqo
        RDBB8T8V+bv003boHhXE9WKNVGw+j0Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622802926;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DvpECzMFaM5oWy3riv7rVLKUeJn6GGTVhrgcSjdUeoQ=;
        b=+b/ff5jFMgcEtpj1CyCBGyzXj5PQ8c9WpgVbYMWyEbsK6Kjimv7c51zki1Ca05DoxUL4FU
        HNmTVAXbGR03zdAw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id /KSUC+0BumC4CgAALh3uQQ
        (envelope-from <colyli@suse.de>); Fri, 04 Jun 2021 10:35:25 +0000
Subject: Re: PROBLEM: bcache related kernel BUG() since Linux 5.12
To:     Rolf Fokkens <rolf@rolffokkens.nl>
Cc:     linux-bcache@vger.kernel.org,
        Thorsten Knabe <linux@thorsten-knabe.de>
References: <58f92cd7-38d1-bc16-2b5f-b68b2db2233b@thorsten-knabe.de>
 <f2f917d5-330b-a5cc-cca1-fe79a32c2140@rolffokkens.nl>
 <7e3c8a62-71d4-11a7-5dd7-137c030f5aad@suse.de>
 <92f2fb24-0d19-939d-a37a-91b9c1da4ac1@thorsten-knabe.de>
 <2a37723c-bc91-351d-5b0e-e7d104f88141@rolffokkens.nl>
 <69319c4e-71fe-5c7d-955f-801fdb9d9cba@suse.de>
 <5df1c881-02e9-f951-5dbd-016a390d8d54@rolffokkens.nl>
From:   Coly Li <colyli@suse.de>
Message-ID: <709c9a11-686d-9b82-b016-e65fdca41f01@suse.de>
Date:   Fri, 4 Jun 2021 18:35:23 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <5df1c881-02e9-f951-5dbd-016a390d8d54@rolffokkens.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/4/21 5:07 PM, Rolf Fokkens wrote:
> Hi Coly, Thorsten,
>
> I survived 48 hours perfectly:
>
> bash-5.0$ uptime
>  10:45:53 up 2 days, 11:05,  1 user,  load average: 2.82, 3.45, 2.67
> bash-5.0$ cat /proc/version
> Linux version 5.12.8-200.rf.fc33.x86_64
> (mockbuild@tb-sandbox-mjolnir.local.tbai.nl) (gcc (GCC) 10.3.1 20210422
> (Red Hat 10.3.1-1), GNU ld version 2.35-18.fc33) #1 SMP Tue Jun 1
> 23:10:39 CEST 2021
> bash-5.0$
>
> Furthermore there are no concerning messages in the syslog.

Hi Rolf,

Thanks for your update. Which kind of applications/workload are running
in the past 2 days ?

Coly Li
