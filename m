Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F3A39251B
	for <lists+linux-bcache@lfdr.de>; Thu, 27 May 2021 04:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbhE0C4t (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 26 May 2021 22:56:49 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:54638 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbhE0C4s (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 26 May 2021 22:56:48 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 606F5218E1;
        Thu, 27 May 2021 02:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622084115; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=69Q2fUXLBqf8vNF74HnM/hoHoUEhYgwv+9sIEJxxfwY=;
        b=yJ9QV0SxrTAbPG0VM0fOqEU+p7IzYwJSIf0whJGZMrDhOt7/dshYHyZziVahvrWpbYVRnL
        NaZAuoubPzXzTeuR//gHzaZ+fjjiuoLsXzAy3V5PCw9Q9bbsPhQW1coSZNmzhDBJ/NYiSE
        j8rryvhEIw7ABbL4DLGPmAhUEi99gnU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622084115;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=69Q2fUXLBqf8vNF74HnM/hoHoUEhYgwv+9sIEJxxfwY=;
        b=cjzbLsi8plJWQeu9ROtixPP70NJQeGr/eroAFnXGIdyIlNQO3LQ7gEWl0S6wTscdfNAOJ2
        DWa3D/55egzRS0Cw==
Received: from director2.suse.de (director2.suse-dmz.suse.de [192.168.254.72])
        by imap.suse.de (Postfix) with ESMTPSA id B28E811A98;
        Thu, 27 May 2021 02:55:14 +0000 (UTC)
To:     Nix <nix@esperi.org.uk>
Cc:     linux-bcache@vger.kernel.org
References: <20210526151450.45211-1-colyli@suse.de>
 <87tumpiiyz.fsf@esperi.org.uk>
From:   Coly Li <colyli@suse.de>
Subject: Re: [PATCH v4] bcache: avoid oversized read request in cache missing
 code path
Message-ID: <2ca4d125-c1d0-0ed0-f654-1b816432ed2e@suse.de>
Date:   Thu, 27 May 2021 10:55:12 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <87tumpiiyz.fsf@esperi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/26/21 11:59 PM, Nix wrote:
> On 26 May 2021, Coly Li said:
>> Current problmatic code can be partially found since Linux v5.13-rc1,
>> therefore all maintained stable kernels should try to apply this fix.
> 
> I thought this crash was observed with 5.12 originally? (I know that's
> why I'm still on 5.11 :) )
> 

My typo, sigh....

The problematic code was in such form since Linux v3.13-rc1,
- the bio related panic was explicitly triggered due to bio changes
since v5.12.
- the overflowed bkey size issue exists for long time too, just no one
reports it before.

Maybe the issue can be found in pre-v3.13 code, but I don't check
because the code logic was not in current form.

Thank you for figure out the typo, I will fix it in next version.

Coly Li
