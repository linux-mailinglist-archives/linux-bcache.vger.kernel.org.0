Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E8B3D9A31
	for <lists+linux-bcache@lfdr.de>; Thu, 29 Jul 2021 02:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbhG2Anq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 28 Jul 2021 20:43:46 -0400
Received: from mx.ewheeler.net ([173.205.220.69]:42211 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232950AbhG2Anq (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 28 Jul 2021 20:43:46 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.ewheeler.net (Postfix) with ESMTPSA id 02BD21A
        for <linux-bcache@vger.kernel.org>; Thu, 29 Jul 2021 00:43:44 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ewheeler.net 02BD21A
Authentication-Results: mail.ewheeler.net; dkim=none
Date:   Thu, 29 Jul 2021 00:43:43 +0000 (UTC)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
X-X-Sender: lists@pop.dreamhost.com
To:     linux-bcache@vger.kernel.org
Subject: Can you grow a bcache cachedev without reformat?
Message-ID: <alpine.LRH.2.21.2107290042300.27704@pop.dreamhost.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello all,

I know you can grow a backing device by unregister/re-register, but what 
about a cache dev?  

Will bcache detect a large cache volume if I unregister/re-register, or 
does it need reformatted with make-bcache -C ?


--
Eric Wheeler
