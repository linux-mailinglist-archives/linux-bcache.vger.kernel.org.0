Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEDE64867A6
	for <lists+linux-bcache@lfdr.de>; Thu,  6 Jan 2022 17:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241233AbiAFQ16 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 6 Jan 2022 11:27:58 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:52872 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241240AbiAFQ1y (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 6 Jan 2022 11:27:54 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 81820210FC;
        Thu,  6 Jan 2022 16:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1641486472; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Rh0hocu1a8+PBf4A1y3U05UCcti/jY/mp9aHCerh1TY=;
        b=IwmHqIMnWfBhhIXBlZK84nLI/Cs5j0HBmabgpW3QGTcQ4Jh9K8BfoStyt5CAiVFiLl0Y7a
        FpEcPXC5inIYGp5DyFR5kgnWF4RjfnZECjIvVX3ZXRrnLWhp0215WHTV7gA1k6ZxQMB8f8
        CEBhCWaSsLreM0/vAZOjmZX9LNPoLAY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1641486472;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Rh0hocu1a8+PBf4A1y3U05UCcti/jY/mp9aHCerh1TY=;
        b=AgvIWgbgsabOfkH1JLG7+WCsj6O1V06A1EgauXcCU+u1Y5YGyOYjAGrW3WMG9i1oBpDDTv
        CB9/4TL0X/6ss7DA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D534D13C5E;
        Thu,  6 Jan 2022 16:27:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 01WdJ4cY12FLDgAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 06 Jan 2022 16:27:51 +0000
Message-ID: <1d2bdf75-145c-9e48-0aed-9a55419bb4a7@suse.de>
Date:   Fri, 7 Jan 2022 00:27:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Content-Language: en-US
To:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
From:   Coly Li <colyli@suse.de>
Subject: On vacation up to Feb 9
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi folks,

I start my vacation now and it ends on Feb 9 after the Chinese Spring 
Festival. During these days I will continue to response email but with 
some latency. If you do have emergent issue to discuss, please notice me 
on the email subject, I will try my best to response in time.

Thank you all.

Coly Li
