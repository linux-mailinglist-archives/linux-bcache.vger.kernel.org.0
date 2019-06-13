Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 166DA44356
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Jun 2019 18:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388039AbfFMQ2o (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 13 Jun 2019 12:28:44 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41330 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730945AbfFMQ2n (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 13 Jun 2019 12:28:43 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 0D5E68EE147;
        Thu, 13 Jun 2019 09:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1560443323;
        bh=bnTJZINKg659sWer2QpR3c5NeLkXTlt8sZRt1buXvPk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ECkUStv+npI9x1oyvMYlUKctnPIORbAWAMPFhOP6is+V2N0dN63FeLtDHVGFmXEN9
         olnXF7NIMaBfyC0lR9pZ5uuKe7/fVu8GYIhaFH5IxI0V4C0qH0rsNexLnTz8aR6g7L
         bXanZK2NoD9Z5mhlTLsmHbmWOatkkzO48mkWks9U=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id DWyDetGG-Y6c; Thu, 13 Jun 2019 09:28:42 -0700 (PDT)
Received: from jarvis.lan (unknown [50.35.68.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 5F8EA8EE0C7;
        Thu, 13 Jun 2019 09:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1560443322;
        bh=bnTJZINKg659sWer2QpR3c5NeLkXTlt8sZRt1buXvPk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=c7M+KVMKOhi/zNVgKex9T2JCLcgRkBWN6q8nLxckxA3LLq79BjndZCUnWrz9y/WQk
         vti4sGZfC6NwRYlQWLwH3hj03jxQ8rT5v0Hj0sypVWw6RcOQQRZXSG8upMqmBtKosz
         U0d3IvxaxlsMbUzAJQgIT8K/Kt0g4EjcaLtBfHUs=
Message-ID: <1560443321.3329.42.camel@HansenPartnership.com>
Subject: Re: [PATCH 1/8] block: add a helper function to read nr_setcs
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     dgilbert@interlog.com, Bart Van Assche <bvanassche@acm.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-btrace@vger.kernel.org,
        kent.overstreet@gmail.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com
Date:   Thu, 13 Jun 2019 09:28:41 -0700
In-Reply-To: <f8ab9587-309b-79a0-e6fc-f6683176f498@interlog.com>
References: <20190613145955.4813-1-chaitanya.kulkarni@wdc.com>
         <20190613145955.4813-2-chaitanya.kulkarni@wdc.com>
         <9abfc2b8-4496-db7a-fcbb-b52102a67f8e@acm.org>
         <f8ab9587-309b-79a0-e6fc-f6683176f498@interlog.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, 2019-06-13 at 12:07 -0400, Douglas Gilbert wrote:
> On 2019-06-13 11:31 a.m., Bart Van Assche wrote:
[...]
> > Please explain what makes you think that part_nr_sects_read() must
> > be protected 
> > by an RCU read lock.
> 
> Dear reviewer,
> Please rephrase the above sentence without the accusative tone.
> Specifically, please do not use the phrase "what makes you think"
> in this or any other code review. For example: "I believe that..."
> is more accurate and less provocative.

Imputing "tone" to email is something we try to avoid because it never
ends well, particularly for non-native speakers. Some languages
(Russian) have no articles and if you take any English phrase and strip
out all the articles it sounds a lot more aggressive.

> Observation: as a Canadian citizen when crossing the US border I
> believe contradicting a US border official with the phrase "what
> makes you think ..." could lead to a rather bad outcome :-)
> Please make review comments with that in mind.

Different situation: we aren't profiling reviewers ...

> Thanks.
> 
> Doug Gilbert
> 
> P.S. Do we have any Linux code-of-conduct for reviewers?

It's the same one for all interactions:

Documentation/process/code-of-conduct-interpretation.rst

But I would remind everyone that diversity isn't just a
gender/race/LGBT issue it also means being understanding of the
potential difficulties non-native speakers have with email in English.

James

