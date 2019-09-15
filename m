Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50A7EB2F40
	for <lists+linux-bcache@lfdr.de>; Sun, 15 Sep 2019 10:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfIOIkU (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 15 Sep 2019 04:40:20 -0400
Received: from m15-57.126.com ([220.181.15.57]:58828 "EHLO m15-57.126.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbfIOIkU (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 15 Sep 2019 04:40:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=AkXUs
        ddo997NBOtuq9nb0xT3pYYPQMjRSF77tv3pWA4=; b=kuew1T0s6o4pYwjb5U6nj
        ns8DY39E+Yt1de0rGIC4GvzQtA2C2f1hONgvnULfJynFGNQH9PHuGe+SPj3cFi7+
        MLIkf0MuaIDoDcerW7F2S99m6ia2zUoObmMSC8DgQQKrR0LvKL25+rYLSAwtGvYh
        8UXdP0TGlx7KcbEAonVs1c=
Received: from nina_2011$126.com ( [106.38.115.23] ) by ajax-webmail-wmsvr57
 (Coremail) ; Sun, 15 Sep 2019 16:40:15 +0800 (CST)
X-Originating-IP: [106.38.115.23]
Date:   Sun, 15 Sep 2019 16:40:15 +0800 (CST)
From:   nina <nina_2011@126.com>
To:     linux-bcache@vger.kernel.org
Subject: A question about bcahe
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.10 build 20190724(ac680a23)
 Copyright (c) 2002-2019 www.mailtech.cn 126com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <1cbad178.1fe5.16d341465a7.Coremail.nina_2011@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: OcqowAD3_6_w+H1dnxVrAA--.19143W
X-CM-SenderInfo: 5qlqtsisqriqqrswhudrp/1tbikhAxEFpD+IsPEgAAsU
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

CgpIaSwgRGVhciBNcgoKSSBoYXZlIGEgcXVlc3Rpb24gdG8gYXNrLiBOb3cgd2UgdXNlIGJjYWNo
ZSBpbiB0aGlzIHNjZW5hcmlvOiAgb25lIG52bWUgYXMgY2FjaGUgYW5kIG11bHRpcGxlIFNBVEEg
ZGlza3MgYXMgZGV2aWNlcywgYW5kIGF2ZyBmaWxlIHNpemUgMU1CLgpXaGF0IGlzIHRoZSByZWFz
b25hYmxlIHJhdGlvIG9mIG52bWUgdG8gU0FUQSBkaXNro78KV2hhdCBpbmRpY2F0b3JzIHNob3Vs
ZCBiZSB1c2VkIHRvIGp1ZGdlIHdoZXRoZXIgdGhlIHJhdGlvIGlzIHJlYXNvbmFibGUgb3Igbm90
PwoKCkkgbG9vayBmb3J3YXJkIHRvIHlvdXIgcmVwbHkuIFRoYW5rIHlvdS4KLS1OaW5h
